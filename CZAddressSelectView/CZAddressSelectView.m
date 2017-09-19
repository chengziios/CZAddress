//
//  CZAddressSelectView.m
//  CZ
//
//  Created by 程健 on 2017/9/16.
//  Copyright © 2017年 程健. All rights reserved.
//

#define RGB(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define CZFontSize(fontSize)        [UIFont systemFontOfSize:fontSize]

//返回设备物理高度/宽度
#define CZScreenHeight     [UIScreen mainScreen].bounds.size.height
#define CZScreenWidth      [UIScreen mainScreen].bounds.size.width
//颜色
#define CZColorBackGround       RGB(246 ,246, 246)      
#define CZColorNavWhite         RGB(248,248,248)
#define CZColorFontBlack        RGB(54 ,54, 54)         
#define CZColorLine             RGB(246 ,246, 246)      
#define CZColorLine2            RGB(235 ,235, 235)      
#define CZColorFontGray         RGB(123 ,123, 123)      
#define CZColorMotif            RGB(246,16,39)          
#define CZColorWhite            RGB(255, 255, 255)      
#define CZColorBlack            RGB(0, 0, 0)            
#define CZColorClear            [UIColor clearColor]    
#define CZColorGray             RGB(231, 231, 231)      
#define CZColorGray1            RGB(187, 187, 187)      
#define CZColorGray2            RGB(190, 190, 190)      
#define CZColorGray3            RGB(146, 146, 146)

#import "UIView+CZCategory.h"
#import "CZAddressSelectView.h"


@interface NSString (CZ)
-(CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size;
+(NSString *)uniqueIdentifier;
@end

@implementation NSString (CZ)
-(CGSize)sizeWithFont:(UIFont *)font size:(CGSize)size
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil];
    CGSize  actualsize =[self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine |
                         NSStringDrawingUsesLineFragmentOrigin |
                         NSStringDrawingUsesFontLeading  attributes:tdic context:nil].size;
    return actualsize;
}

+(NSString *)uniqueIdentifier
{
    long x =arc4random() % 1000000;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * str = [formatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%ld",str,x];
}
@end


static  CGFloat  const  CZAddressSelectContentViewHeight = 400;
static  CGFloat  const  CZAddressSelectTopTabbarHeight = 45;

@implementation CZAddressSelectModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"children" : [CZAddressSelectModel class]};
}
@end

@implementation CZAddressSelectModels
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"items" : [CZAddressSelectModel class]};
}
@end

@class CZAddressSelectTopTabbar;
@protocol CZAddressSelectTopTabbarDelegate <NSObject>
-(void)didSelectWithCancel:(CZAddressSelectTopTabbar *)topTabbar;
-(void)topTabbar:(CZAddressSelectTopTabbar *)topTabbar didSelectWithIndex:(NSInteger)index;
@end

@interface CZAddressSelectTopTabbar : UIView
@property(nonatomic,strong)NSMutableArray *datas;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,weak)id<CZAddressSelectTopTabbarDelegate>delegate;

-(void)selectWithIndex:(NSInteger)index;

-(void)addData:(CZAddressSelectModel *)data withIndex:(NSInteger)index;
@end

@implementation CZAddressSelectTopTabbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *lineView =[[UIView alloc] initWithFrame:CGRectMake(0, CZAddressSelectTopTabbarHeight-0.5, self.width, 0.5)];
        [lineView setBackgroundColor:RGB(220 ,220, 220)];
        [self addSubview:lineView];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CZAddressSelectTopTabbarHeight-2, 40, 2)];
        [_lineView setBackgroundColor:CZColorMotif];
        [self addSubview:_lineView];
        
        UIButton *cancelButton = [UIButton buttonWithType:0];
        [cancelButton setFrame:CGRectMake(self.width-50, 0, 50, self.height)];
        [cancelButton setTitle:@"取消" forState:0];
        [cancelButton setTitleColor:CZColorGray3 forState:0];
        [cancelButton.titleLabel setFont:CZFontSize(14)];
        [cancelButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.tag = 888;
        [self addSubview:cancelButton];

        _datas = [NSMutableArray new];

        float left = 15;
        NSString *text = @"请选择";
        UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBarItem setTitle:text forState:UIControlStateNormal];
        [topBarItem setTitleColor:CZColorFontBlack forState:UIControlStateNormal];
        [topBarItem.titleLabel setFont:CZFontSize(14)];
        [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBarItem setTag:100];
        [self addSubview:topBarItem];
        
        CGSize size = [text sizeWithFont:topBarItem.titleLabel.font size:CGSizeMake(100, 20)];
        
        [topBarItem setFrame:CGRectMake(left, 0, size.width, self.height)];
        self.lineView.width = topBarItem.width;
        self.lineView.left = topBarItem.left;
    }
    return self;
}

-(void)addData:(CZAddressSelectModel *)data withIndex:(NSInteger)index
{
    if (_datas.count>0) {
        for (NSInteger i = _datas.count-1; i >= 0; i--) {
            if (i >= index) {
                [_datas removeObjectAtIndex:i];
            }
        }
    }
    
    [_datas addObject:data];
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]&&view.tag != 888) {
            [view removeFromSuperview];
        }
    }
    
    float left = 15;
    
    for (int i = 0; i < _datas.count; i++) {
        
        CZAddressSelectModel *model = _datas[i];
        
        NSString *text = model.region_name;
        
        UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBarItem setTitle:text forState:UIControlStateNormal];
        [topBarItem setTitleColor:CZColorFontBlack forState:UIControlStateNormal];
        [topBarItem.titleLabel setFont:CZFontSize(14)];
        [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBarItem setTag:100+i];
        [self addSubview:topBarItem];
        
        CGSize size = [text sizeWithFont:topBarItem.titleLabel.font size:CGSizeMake(100, 20)];
        
        [topBarItem setFrame:CGRectMake(left, 0, size.width, self.height)];
        
        left += (size.width+15);
    }
    
    if (index<2) {
        
        NSString *text = @"请选择";
        UIButton * topBarItem = [UIButton buttonWithType:UIButtonTypeCustom];
        [topBarItem setTitle:text forState:UIControlStateNormal];
        [topBarItem setTitleColor:CZColorFontBlack forState:UIControlStateNormal];
        [topBarItem.titleLabel setFont:CZFontSize(14)];
        [topBarItem addTarget:self action:@selector(topBarItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [topBarItem setTag:100+index+1];
        [self addSubview:topBarItem];
        
        CGSize size = [text sizeWithFont:topBarItem.titleLabel.font size:CGSizeMake(100, 20)];
        
        [topBarItem setFrame:CGRectMake(left, 0, size.width, self.height)];
        
        left += (size.width+15);
    }
    
    [self selectWithIndex:index<2?index+1:index];
}

-(void)selectWithIndex:(NSInteger)index
{
    UIButton *button = [self viewWithTag:index+100];
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.25 animations:^{
        typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.lineView.width = button.width;
        strongSelf.lineView.left = button.left;
    }];
}

-(void)topBarItemClick:(UIButton *)sender
{
    [self selectWithIndex:sender.tag-100];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(topTabbar:didSelectWithIndex:)]) {
        [self.delegate topTabbar:self didSelectWithIndex:sender.tag-100];
    }
}

-(void)closeClick:(UIButton *)sender
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didSelectWithCancel:)]) {
        [self.delegate didSelectWithCancel:self];
    }
}
@end

static  CGFloat  const  CZAddressSelectCellHeight = 45;

@interface CZAddressSelectCell : UITableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)CZAddressSelectModel *model;
@end

@implementation CZAddressSelectCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:CZColorWhite];
    
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, CZAddressSelectCellHeight-0.5, CZScreenWidth-12, 0.5)];
        [lineView setBackgroundColor:CZColorLine2];
        [self.contentView addSubview:lineView];
    
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [_titleLabel setLeft:12];
    [_titleLabel setHeight:20];
    [_titleLabel setWidth:self.contentView.width-80];
    [_titleLabel setCenterY:self.contentView.centerY];
}

-(void)setModel:(CZAddressSelectModel *)model
{
    _model = model;
    [_titleLabel setText:model.region_name];
    [self layoutSubviews];
}

#pragma mark - getters and setters
-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:CZFontSize(14)];
        [_titleLabel setTextColor:CZColorFontBlack];
    }
    return _titleLabel;
}
@end



@interface CZAddressSelectView()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) CZAddressSelectTopTabbar *topTabbar;

@property (nonatomic,strong) NSArray * dataSouce;
@property (nonatomic,assign) NSInteger provinceIndex;
@property (nonatomic,assign) NSInteger cityIndex;
@property (nonatomic,assign) NSInteger districtIndex;

@property (nonatomic,strong) CZAddressSelectViewWithComplete complete;
@end

@implementation CZAddressSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _dataSouce = [CZAddressSelectView addressDatas];
        
        [self setBackgroundColor:CZColorClear];
        [self addSubview:self.backView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.topTabbar];
        [self.contentView addSubview:self.scrollView];
        [self addTableViewWithIndex:0];
        
        _provinceIndex = -1;
        _cityIndex = -1;
        _districtIndex = -1;
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CZAddressSelectCellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 0){
        return self.dataSouce.count;
    }else if (tableView.tag == 1){
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        return model.children.count;
    }else if (tableView.tag == 2){
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        CZAddressSelectModel *model1 = [model.children objectAtIndex:_cityIndex];
        return model1.children.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 0){
        static NSString *SimapleCell = @"PQDChatInputMessageCell";
        CZAddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:SimapleCell];
        if (!cell) {
            cell = [[CZAddressSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimapleCell];
        }
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:indexPath.row];
        [cell setModel:model];
        if (indexPath.row == _provinceIndex) {
            [cell.titleLabel setTextColor:CZColorMotif];
        }else{
            [cell.titleLabel setTextColor:CZColorFontBlack];
        }
        return cell;
        
    }else if (tableView.tag == 1){
    
        static NSString *SimapleCell = @"CZAddressSelectCell2";
        CZAddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:SimapleCell];
        if (!cell) {
            cell = [[CZAddressSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimapleCell];
        }
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        CZAddressSelectModel *model1 = [model.children objectAtIndex:indexPath.row];
        [cell setModel:model1];
        if (indexPath.row == _cityIndex) {
            [cell.titleLabel setTextColor:CZColorMotif];
        }else{
            [cell.titleLabel setTextColor:CZColorFontBlack];
        }
        return cell;
        
    }else if (tableView.tag == 2){
        
        static NSString *SimapleCell = @"CZAddressSelectCell3";
        CZAddressSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:SimapleCell];
        if (!cell) {
            cell = [[CZAddressSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SimapleCell];
        }
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        CZAddressSelectModel *model1 = [model.children objectAtIndex:_cityIndex];
        CZAddressSelectModel *model2 = [model1.children objectAtIndex:indexPath.row];
        [cell setModel:model2];
        if (indexPath.row == _districtIndex) {
            [cell.titleLabel setTextColor:CZColorMotif];
        }else{
            [cell.titleLabel setTextColor:CZColorFontBlack];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView.tag == 0){
        
        _provinceIndex = indexPath.row;
        [self addTableViewWithIndex:1];
        [tableView reloadData];
        
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:indexPath.row];
        [self.topTabbar addData:model withIndex:0];
        
        
    }else if (tableView.tag == 1){
        
        _cityIndex = indexPath.row;
        [self addTableViewWithIndex:2];
        [tableView reloadData];
        
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        CZAddressSelectModel *model1 = [model.children objectAtIndex:indexPath.row];
        [self.topTabbar addData:model1 withIndex:1];
        
    }else if (tableView.tag == 2){
        
        _districtIndex =indexPath.row;
        [tableView reloadData];
        
        CZAddressSelectModel *model = [self.dataSouce objectAtIndex:_provinceIndex];
        CZAddressSelectModel *model1 = [model.children objectAtIndex:_cityIndex];
        CZAddressSelectModel *model2 = [model1.children objectAtIndex:indexPath.row];
        [self.topTabbar addData:model2 withIndex:2];
        
        if (self.complete) {
            self.complete(model, model1, model2);
        }
        [self didSelectWithCancel:nil];
    }
}

#pragma mark - CZAddressSelectTopTabbarDelegate
-(void)didSelectWithCancel:(CZAddressSelectTopTabbar *)topTabbar
{
    __weak typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:5.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf.backView setAlpha:0];
                         [strongSelf.contentView setTop:strongSelf.height];
                     } completion:^(BOOL finished) {
                         typeof(weakSelf) strongSelf = weakSelf;
                         [strongSelf removeFromSuperview];
                     }];
}

-(void)topTabbar:(CZAddressSelectTopTabbar *)topTabbar didSelectWithIndex:(NSInteger)index
{
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width*index, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.scrollView) {
        [self.topTabbar selectWithIndex:scrollView.contentOffset.x/self.scrollView.width];
    }
}

#pragma mark - private method
- (void)addTableViewWithIndex:(NSInteger)index
{
    if (index == 0) {
        _provinceIndex = -1;
        _cityIndex = -1;
        _districtIndex = -1;
    }
    
    if (index == 1) {
        _cityIndex = -1;
        _districtIndex = -1;
    }
    
    if (index == 2) {
        _districtIndex = -1;
    }
    
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag >= index) {
            [view removeFromSuperview];
        }
    }
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(index * self.scrollView.width,0,self.scrollView.width, self.scrollView.height) style:UITableViewStylePlain];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:CZColorWhite];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView setTag:index];
    [_scrollView addSubview:tableView];
    [_scrollView setContentSize:CGSizeMake((index+1)*self.scrollView.width, self.scrollView.height)];
    [_scrollView setContentOffset:CGPointMake(index*self.scrollView.width , 0) animated:YES];
}

-(void)setProvince:(NSString *)province
              city:(NSString *)city
          district:(NSString *)district
{
    if ([province length]!=0&&[city length]!=0&&[district length]!=0) {
        
        NSArray *addressDatas = [CZAddressSelectView addressDatas];

        for (int i = 0; i < [addressDatas count]; i++) {
            CZAddressSelectModel *model = addressDatas[i];
            if ([model.region_id isEqualToString:province]) {
                [self.topTabbar addData:model withIndex:0];
                _provinceIndex = i;
                
                for (int i1 = 0; i1 < [model.children count]; i1++) {
                    CZAddressSelectModel *model1 = model.children[i1];
                    if ([model1.region_id isEqualToString:city]) {
                        [self addTableViewWithIndex:1];
                        [self.topTabbar addData:model1 withIndex:1];
                        _cityIndex = i1;
                        
                        for (int i2 = 0; i2 < [model1.children count]; i2++) {
                            CZAddressSelectModel *model2 = model1.children[i2];
                            if ([model2.region_id isEqualToString:district]) {

                                [self addTableViewWithIndex:2];
                                [self.topTabbar addData:model2 withIndex:2];
                                _districtIndex = i2;
                                
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        for (UIView *view  in self.scrollView.subviews) {
            if ([view isKindOfClass:[UITableView class]]) {
                [(UITableView *)view reloadData];
            }
        }
        
        [_scrollView setContentOffset:CGPointMake(0 , 0) animated:NO];
        [self.topTabbar selectWithIndex:0];
    }
}

#pragma mark - getters and setters
-(UIView *)backView
{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        [_backView setBackgroundColor:[UIColor blackColor]];
        [_backView setAlpha:0];
//        [_backView addTarget:self action:@selector(closeClick)];
    }
    return _backView;
}

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, CZAddressSelectContentViewHeight)];
        [_contentView setBackgroundColor:CZColorWhite];
    }
    return _contentView;
}

-(CZAddressSelectTopTabbar *)topTabbar
{
    if (!_topTabbar) {
        _topTabbar = [[CZAddressSelectTopTabbar alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, CZAddressSelectTopTabbarHeight)];
        [_topTabbar setDelegate:(id<CZAddressSelectTopTabbarDelegate>)self];
    }
    return _topTabbar;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topTabbar.frame), self.contentView.width, self.contentView.height-CGRectGetMaxY(self.topTabbar.frame))];
        _scrollView.contentSize = CGSizeMake(0, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}


#pragma mark - publice method
+(void)showWithComplete:(CZAddressSelectViewWithComplete)complete
               province:(NSString *)province
                   city:(NSString *)city
               district:(NSString *)district
{
    UIView *superView = [UIApplication sharedApplication].keyWindow;
    CZAddressSelectView *typeView = [[CZAddressSelectView alloc] initWithFrame:superView.bounds];
    [superView addSubview:typeView];
    
    [typeView setComplete:complete];
    
    [typeView.contentView setTop:typeView.height];
    [typeView.backView setAlpha:0];
    [typeView setProvince:province city:city district:district];

    [UIView animateWithDuration:0.5f
                          delay:0.0f
         usingSpringWithDamping:1.0f
          initialSpringVelocity:5.0f
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [typeView.contentView setTop:typeView.height-CZAddressSelectContentViewHeight];
                         [typeView.backView setAlpha:0.7];
                     } completion:^(BOOL finished) {
                         
                     }];
}

+(NSArray *)addressDatas
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.json" ofType:@""];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
    //这里用了yy的模型转换架构，运用的实际项目可以替换
    CZAddressSelectModels *models = [CZAddressSelectModels modelWithJSON:dic];
    return models.items;
}
@end





