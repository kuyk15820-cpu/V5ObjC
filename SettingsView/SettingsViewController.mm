#import "SettingsViewController.h"
#import "AppInfoCell.h"
#import "LinkCreditCell.h"
#import "HeaderLabel.h"

// นิยามค่าสีสำหรับ Color Extensions เดิม ในสไตล์ UIColor Category/Macro
#define UIColorFromRGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define DISCORD_COLOR UIColorFromRGB(88, 101, 242)
#define GITHUB_COLOR UIColorFromRGB(36, 41, 47)

@interface SettingsViewController ()
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ตั้งค่า Navigation Bar
    self.title = @"Info";
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    
    // สร้างปุ่มปิดด้านขวาบน (เทียบเท่า xmark button ใน toolbar)
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"xmark"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(dismissController)];
    self.navigationItem.rightBarButtonItem = closeButton;
    
    // สร้าง UITableView แบบ InsetGrouped (เพื่อให้สไตล์เหมือน List ใน SwiftUI)
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleInsetGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // ลงทะเบียนเซลล์คัสตอม
    [self.tableView registerClass:[AppInfoCell class] forCellReuseIdentifier:@"AppInfoCell"];
    [self.tableView registerClass:[LinkCreditCell class] forCellReuseIdentifier:@"LinkCreditCell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - Actions

- (void)dismissController {
    // เทียบเท่ากับ dismiss() ใน SwiftUI
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2; // Section 1: About, Section 2: Credits
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1; // ทั้งสอง Section มีอย่างละ 1 แถวตามโค้ดต้นฉบับ
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        AppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppInfoCell" forIndexPath:indexPath];
        // ส่งเวอร์ชัน "Beta 1" เข้าไปแสดงผล
        [cell configureWithBuild:@"Beta 1"];
        return cell;
    } else {
        LinkCreditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LinkCreditCell" forIndexPath:indexPath];
        
        // ดึงภาพ "mineek" จาก Assets และใส่รายละเอียดเหมือน LinkCreditCell เดิม
        UIImage *avatar = [UIImage imageNamed:@"mineek"];
        [cell configureWithImage:avatar
                            name:@"F1X3R"
                     description:@"Developer from TGS Team"
                             url:@"tg://user?id=6105731078"];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

// ประกอบร่าง Header ด้วย HeaderLabel คัสตอมที่เราทำไว้
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [[HeaderLabel alloc] initWithText:@"About" icon:@"info.circle"];
    } else if (section == 1) {
        return [[HeaderLabel alloc] initWithText:@"Credits" icon:@"star"];
    }
    return nil;
}

// กำหนดความสูงของ Header เพื่อเว้นระยะให้สวยงาม
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 32.0;
}

// ดักจับการแตะที่เซลล์ (เทียบเท่า Button Action บน LinkCreditCell)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell isKindOfClass:[LinkCreditCell class]]) {
            LinkCreditCell *creditCell = (LinkCreditCell *)cell;
            
            if (creditCell.urlString && creditCell.urlString.length > 0) {
                NSURL *url = [NSURL URLWithString:creditCell.urlString];
                
                // สั่งเปิด URL (เทียบเท่ากับ openURL ใน SwiftUI)
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                }
            }
        }
    }
}

@end
