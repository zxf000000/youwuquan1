//
//  XFAddAuthTableViewController.m
//  youwuquan
//
//  Created by mr.zhou on 2017/11/17.
//  Copyright © 2017年 mr.zhou. All rights reserved.
//

#import "XFAddAuthTableViewController.h"
#import "XFYwqAlertView.h"

typedef NS_ENUM(NSInteger, ImagePickerType) {
  
    IdCardUp,
    IdCardWithMan,
    Cer,
    
};

@interface XFAddAuthTableViewController () <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIButton *certificateButton;
@property (weak, nonatomic) IBOutlet UIButton *idCardUpButton;
@property (weak, nonatomic) IBOutlet UIButton *idCardDownButton;
@property (weak, nonatomic) IBOutlet UITextField *idNumberTextFioeld;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *wxTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *waterNumber;

@property (nonatomic,assign) ImagePickerType pickerType;


@end

@implementation XFAddAuthTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"申请认证";
    self.addButton.layer.cornerRadius = 22;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 20;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.01;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (IBAction)clickAddbutton:(id)sender {
    

    
    if (![self.nameTextField.text isName] && self.nameTextField.text != nil) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的姓名"];
        
        return;
    }
    
    if (![self.phoneTextField.text isPhoneNumber]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的手机号码"];
        
        return;
    }
    
    if (![self.wxTextField.text isWxNumbver]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的微信号码"];
        
        return;
    }
    
    if (![self.emailTextField.text isEmail] && self.emailTextField.text != nil) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入正确的邮箱地址"];
        
        return;
    }
    
    if (![self.idNumberTextFioeld.text isIdCard]) {
        
        [XFToolManager showProgressInWindowWithString:@"身份证号格式错误"];
        
        return;
    }
    
    if (self.idCardUpButton.currentImage == [UIImage imageNamed:@"my_add"]) {
        
        [XFToolManager showProgressInWindowWithString:@"请添加身份证照片"];
        
        return;
        
    }
    
    if (self.idCardDownButton.currentImage == [UIImage imageNamed:@"my_add"]) {
        
        [XFToolManager showProgressInWindowWithString:@"请添加手持身份证照片"];
        
        return;
    }
    
    if (![self.waterNumber.text isHasContent]) {
        
        [XFToolManager showProgressInWindowWithString:@"请输入转账流水号"];
        
        return;
        
    }
    if (self.certificateButton.currentImage == [UIImage imageNamed:@"my_add"]) {
        
        [XFToolManager showProgressInWindowWithString:@"请上传转账凭证"];
        
        return;
    }

    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    [HUD hideAnimated:YES afterDelay:0.5];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 发送成功
        XFYwqAlertView *alertView = [XFYwqAlertView showToView:self.view withTitle:@"提交成功!" detail:@"1-3个工作日内会有工作人员联系你,请保持手机畅通!" doneButtonTitle:@"确定"];
        
        [alertView showAnimation];
    });
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
       
        switch (self.pickerType) {
            case IdCardUp:
            {
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                [self.idCardUpButton setImage:image forState:(UIControlStateNormal)];
            }
                break;
            case IdCardWithMan:
            {
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                [self.idCardDownButton setImage:image forState:(UIControlStateNormal)];
            }
                break;
            case Cer:
            {
                UIImage *image = info[UIImagePickerControllerOriginalImage];
                [self.certificateButton setImage:image forState:(UIControlStateNormal)];
            }
                break;
                
            default:
                break;
        }
        
    }];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)callPhotoLibraryWithType:(ImagePickerType)type {
    
    self.pickerType = type;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    
    UIAlertAction *actionCamera = [UIAlertAction actionWithTitle:@"相机拍摄" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
        
        imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePick.delegate = self;
        [self presentViewController:imagePick animated:YES completion:nil];
    }];
    
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相册选择" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
        
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePick.delegate = self;
        [self presentViewController:imagePick animated:YES completion:nil];
    }];
    
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];

    [alert addAction:actionCamera];
    [alert addAction:actionPhoto];
    [alert addAction:actionCancel];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)clickcertificateButton:(id)sender {
    
    [self callPhotoLibraryWithType:Cer];
    
}

- (IBAction)clickIdUpButton:(id)sender {

    [self callPhotoLibraryWithType:IdCardUp];

}

- (IBAction)clickIdDownButton:(id)sender {

    [self callPhotoLibraryWithType:IdCardWithMan];

}

@end
