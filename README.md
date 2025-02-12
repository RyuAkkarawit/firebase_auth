# Flutter Firebase Authentication Demo

โปรเจกต์นี้เป็นตัวอย่างการใช้งาน Firebase Authentication ร่วมกับ Flutter เพื่อสร้างระบบลงทะเบียน, เข้าสู่ระบบ, และจัดการบัญชีผู้ใช้เบื้องต้น

## โครงสร้างโปรเจกต์

โปรเจกต์นี้ประกอบด้วยไฟล์หลักๆ ดังนี้:

*   **main.dart:**  ไฟล์หลักของแอปพลิเคชัน ทำหน้าที่เริ่มต้น Firebase และกำหนด routing ของแอป
*   **create\_account\_page.dart:** หน้าจอสำหรับการสร้างบัญชีผู้ใช้ใหม่
*   **login\_page.dart:** หน้าจอสำหรับการเข้าสู่ระบบ
*   **home\_page.dart:** หน้าจอหลักของแอปพลิเคชัน แสดงข้อมูลผู้ใช้เมื่อเข้าสู่ระบบแล้ว หรือปุ่มสำหรับเข้าสู่ระบบ/สร้างบัญชี
*   **forgot\_password\_page.dart:** หน้าจอสำหรับการรีเซ็ตรหัสผ่าน
*   **firebase\_options.dart:** ไฟล์ที่สร้างขึ้นอัตโนมัติโดย FlutterFire CLI, ใช้สำหรับการตั้งค่า Firebase ในแต่ละแพลตฟอร์ม (Android, iOS, Web, ฯลฯ)

## คำอธิบายฟังก์ชัน (Function Descriptions)

### `main.dart`

*   **`main()`**:
    *   ฟังก์ชันหลักที่เริ่มต้นการทำงานของแอป
    *   เรียก `Firebase.initializeApp()` เพื่อเริ่มต้น Firebase ด้วยการตั้งค่าจาก `DefaultFirebaseOptions.currentPlatform`
    *   เรียก `runApp(MyApp())` เพื่อเริ่ม Flutter application
*   **`MyApp`**:
    *   `StatelessWidget` หลักของแอป
    *   ใช้ `MaterialApp` เพื่อกำหนด:
        *   `title`: ชื่อแอป
        *   `theme`: ธีมสีของแอป (Material 3)
        *   `initialRoute`: หน้าแรกที่จะแสดงเมื่อเปิดแอป ('/home')
        *   `routes`: กำหนดเส้นทาง (routes) ของแอป และเชื่อมโยงแต่ละ route กับ Widget ที่เกี่ยวข้อง:
            *   `'/login'`: `LoginPage()`
            *   `'/create_account'`: `CreateAccountPage()`
            *   `'/home'`: `HomePage()`
            *   `'/forgot_password'`: `ForgotPasswordPage()`

### `create_account_page.dart`

*   **`CreateAccountPage`**:
    *   `StatelessWidget` ที่แสดงหน้าจอสร้างบัญชี
    *   ใช้ `Scaffold` เป็นโครงสร้างหลัก
    *   `_emailController`, `_passwordController`, `_confirmPasswordController`: `TextEditingController` สำหรับจัดการ input จากช่องกรอก email, password, และ confirm password
    *   `_formKey`: `GlobalKey<FormState>` สำหรับ validate form
    *   **`build()`**: สร้าง UI ของหน้าจอ:
        *   `AppBar`: แถบด้านบน พร้อม title และปุ่ม back
        *   `Container`: ตกแต่งพื้นหลังด้วย `LinearGradient`
        *   `LayoutBuilder`, `SingleChildScrollView`, `ConstrainedBox`, `IntrinsicHeight`:  ช่วยให้ UI responsive และ scroll ได้อย่างถูกต้อง เมื่อ keyboard แสดงขึ้นมา, ป้องกัน overflow
        *   `Form`: ครอบคลุม TextFormFields และปุ่ม
        *   `Column`: จัดเรียง widget ในแนวตั้ง
        *   `_buildTextField()`: สร้าง `TextFormField` (ช่องกรอกข้อมูล) แต่ละช่อง (email, password, confirm password)
        *   `ElevatedButton`: ปุ่ม "Create Account"  เรียก `_createAccount()` เมื่อถูกกด
        *   `TextButton`: ปุ่ม "Already have an account? Sign In" นำทางไปยังหน้า login
    *   **`_buildTextField()`**: สร้าง `TextFormField` แบบกำหนดเอง
        *   รับ parameters ต่างๆ เช่น controller, label, hint, icon, keyboard type, obscure text, และ validator
        *   กำหนด `InputDecoration` สวยงาม พร้อม icon, hint text, และ border
        *   `validator`: ตรวจสอบความถูกต้องของ input (เช่น email ต้องมี @, password ต้องยาวพอ, confirm password ต้องตรงกับ password)
        *   คืนค่า `TextFormField` ที่สร้างขึ้น
    *   **`_createAccount()`**:  จัดการการสร้างบัญชีผู้ใช้:
        *   เรียก `FirebaseAuth.instance.createUserWithEmailAndPassword()` เพื่อสร้างบัญชีด้วย email และ password
        *   แสดง `CircularProgressIndicator` ขณะกำลังประมวลผล
        *   แสดง dialog แจ้งเตือนเมื่อ:
            *   สร้างบัญชีสำเร็จ (`_showSuccessDialog()`)
            *   เกิดข้อผิดพลาด (`_showErrorDialog()`) จัดการ `FirebaseAuthException` ต่างๆ (weak-password, email-already-in-use, ฯลฯ)
    *   **`_showErrorDialog()`**: แสดง `AlertDialog` แจ้งข้อผิดพลาด
    *   **`_showSuccessDialog()`**: แสดง `AlertDialog` แจ้งว่าสร้างบัญชีสำเร็จ และนำทางไปยังหน้า login

### `login_page.dart`

* **`LoginPage`**:
    *   `StatefulWidget` ที่แสดงหน้าจอเข้าสู่ระบบ
    *   `_emailController`, `_passwordController`: `TextEditingController` สำหรับจัดการ input จากช่องกรอก email และ password
    *   `_formKey`: `GlobalKey<FormState>` สำหรับ validate form
    *   **`build()`**: สร้าง UI ของหน้าจอ
        *   คล้ายกับ `CreateAccountPage` แต่มี:
            * `TextFormField` สำหรับ email และ password
            * `ElevatedButton`: ปุ่ม "Login" เรียก `_login()` เมื่อถูกกด
            * `TextButton`: ปุ่ม "Forgot Password?" นำทางไปยังหน้า `forgot_password`
            * `Row` และ `GestureDetector` สร้างลิงค์ "Don't have an account? Sign Up" นำทางไปยังหน้า Create Account
    *   **`_buildTextField()`**: เหมือนกับใน `create_account_page.dart`
    *   **`_buildLoginButton()`**: สร้างปุ่ม Login
    *   **`_buildForgotPasswordButton()`**: สร้างปุ่ม Forgot Password
    *   **`_buildSignUpButton()`**: สร้างลิงค์ Sign Up
    *   **`_login()`**: จัดการการเข้าสู่ระบบ
        *   เรียก `FirebaseAuth.instance.signInWithEmailAndPassword()`
        *   แสดง `CircularProgressIndicator` ขณะประมวลผล
        *   แสดง dialog แจ้งเตือน:
            *   เข้าสู่ระบบสำเร็จ: นำทางไปยังหน้า `/home`
            *   เกิดข้อผิดพลาด:  จัดการ `FirebaseAuthException` (user-not-found, wrong-password, ฯลฯ) และแสดงข้อความ error
    *   **`_showErrorDialog()`**: เหมือนกับใน `create_account_page.dart`

### `home_page.dart`

*   **`HomePage`**:
    *   `StatefulWidget` ที่แสดงหน้าจอหลัก
    *   `_user`: เก็บข้อมูลผู้ใช้ปัจจุบัน (`User?`)
    *   **`initState()`**: เรียก `_checkCurrentUser()` เมื่อ Widget ถูกสร้าง
    *   **`_checkCurrentUser()`**:
        *   ตรวจสอบผู้ใช้ที่เข้าสู่ระบบอยู่ (`FirebaseAuth.instance.currentUser`)
        *   ใช้ `FirebaseAuth.instance.authStateChanges().listen()` เพื่อติดตามการเปลี่ยนแปลงสถานะการล็อกอิน (login/logout) และอัปเดต `_user`
    *   **`_signOut()`**:
        *   เรียก `FirebaseAuth.instance.signOut()` เพื่อออกจากระบบ
        *   ใช้ `Navigator.pushReplacementNamed(context, '/home')` เพื่อนำทางไปยังหน้า Home ใหม่ (ลบ history การเข้าสู่ระบบก่อนหน้า)
    *   **`build()`**: สร้าง UI
        *   `AppBar`:  แสดงปุ่ม logout ถ้าผู้ใช้ login อยู่
        *   `Container`:  ตกแต่งพื้นหลัง
        *   `Center`, `Padding`: จัด layout
        *   `_buildContent()`: สร้างเนื้อหาตามสถานะ login
    *   **`_buildContent()`**: เลือกแสดง `_buildLoggedInContent()` หรือ `_buildLoggedOutContent()`
    *   **`_buildLoggedInContent()`**: แสดงเมื่อผู้ใช้เข้าสู่ระบบแล้ว
        *   แสดง icon, ข้อความต้อนรับ (แสดง email หรือ displayName ถ้ามี), และปุ่ม "Sign Out"
    *   **`_buildLoggedOutContent()`**: แสดงเมื่อยังไม่ได้เข้าสู่ระบบ
        *   แสดง icon, ข้อความต้อนรับ, ข้อความเชิญชวนให้ login/create account, และปุ่ม "Login" และ "Create Account"
    *   **`_buildAuthButton()`**: สร้างปุ่ม Login และ Create Account (ใช้ `ElevatedButton` และ `OutlinedButton`)

### `forgot_password_page.dart`

*   **`ForgotPasswordPage`**:
    *   `StatefulWidget` สำหรับหน้า "ลืมรหัสผ่าน"
    *   `_emailController`:  `TextEditingController` สำหรับช่องกรอก email
    *   `_formKey`: `GlobalKey<FormState>` สำหรับ validate form
    *   **`build()`**: สร้าง UI:
        *   `Container`:  ตกแต่งพื้นหลัง
        *   `SafeArea`, `Center`, `SingleChildScrollView`, `Form`, `Column`: จัด layout
        *   `_buildTextField()`: สร้างช่องกรอก email
        *   `_buildResetButton()`: สร้างปุ่ม "Send Reset Link"
    *   **`_buildTextField()`**: เหมือนกับในหน้าอื่นๆ
    *   **`_buildResetButton()`**: สร้างปุ่มสำหรับส่งลิงก์รีเซ็ตรหัสผ่าน
    *   **`_resetPassword()`**:
        *   เรียก `FirebaseAuth.instance.sendPasswordResetEmail()` เพื่อส่ง email รีเซ็ตรหัสผ่าน
        *   แสดง `CircularProgressIndicator`
        *   แสดง dialog:
            *   ส่ง email สำเร็จ: `_showSuccessDialog()`
            *   เกิดข้อผิดพลาด: `_showErrorDialog()` จัดการ `FirebaseAuthException`
    *   **`_showErrorDialog()`**, **`_showSuccessDialog()`**: เหมือนกับในหน้าอื่นๆ

## สรุป
README นี้ได้ให้ภาพรวมของโค้ดทั้งหมดในโปรเจ็กต์ของคุณ อธิบายการทำงานของแต่ละ Widget และฟังก์ชันที่สำคัญ รวมถึงวิธีการทำงานร่วมกับ Firebase Authentication อย่างละเอียด ทำให้ผู้ที่เข้ามาดูโปรเจกต์ของคุณสามารถเข้าใจและนำไปพัฒนาต่อยอดได้ง่ายขึ้น
