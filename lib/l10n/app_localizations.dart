import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // Home Screen
      'discover_grants': 'Discover Grants',
      'search_grants': 'Search grants...',
      'filter': 'Filter',
      'no_grants_found': 'No grants found',
      'adjust_filters': 'Try adjusting your search or filters',

      // Grant Status
      'status_open': 'Open',
      'status_closed': 'Closed',
      'status_upcoming': 'Upcoming',

      // Grant Detail Screen
      'apply_now': 'Apply Now',
      'save': 'Save',
      'unsave': 'Unsave',
      'grant_details': 'Grant Details',
      'status': 'Status',
      'deadline': 'Deadline',
      'amount': 'Amount',
      'up_to': 'Up to',
      'issuing_body': 'Issuing Body',
      'eligibility': 'Eligibility',
      'overview': 'Overview',

      // Filter Dialog
      'filter_grants': 'Filter Grants',
      'grant_status': 'Grant Status',
      'all_statuses': 'All Statuses',
      'open': 'Open',
      'closed': 'Closed',
      'upcoming': 'Upcoming',
      'eligibility_criteria': 'Eligibility Criteria',
      'all_eligibility': 'All Eligibility',
      'reset': 'Reset',
      'apply_filters': 'Apply Filters',

      // Profile Screen
      'profile': 'Profile',
      'settings': 'Settings',
      'saved_grants': 'Saved Grants',
      'notifications': 'Notifications',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'support': 'Support',
      'help_center': 'Help Center',
      'privacy_policy': 'Privacy Policy',
      'terms_of_use': 'Terms of Use',
      'about': 'About',
      'sign_out': 'Sign Out',
      'signing_out': 'Signing out...',

      // Language Screen
      'select_language': 'Select Language',
      'english': 'English (US)',
      'chinese': 'Chinese (Simplified)',

      // Saved Grants Screen
      'your_saved_grants': 'Your Saved Grants',
      'no_saved_grants': 'No saved grants yet',
      'save_grants_message': 'Grants you save will appear here',

      // Help Center Screen
      'help_center_title': 'Help Center',
      'faq': 'FAQ',
      'question_1': 'How do I apply for a grant?',
      'answer_1':
          'Click on any grant card to view details, then tap "Apply Now" to be redirected to the official application page.',
      'question_2': 'How do I save a grant for later?',
      'answer_2':
          'On the grant detail page, tap the "Save" button. You can view all saved grants from your profile.',
      'question_3': 'What does each grant status mean?',
      'answer_3':
          'Open: Currently accepting applications\nClosed: No longer accepting applications\nUpcoming: Will open soon',
      'question_4': 'How often is grant information updated?',
      'answer_4': 'Grant information is updated daily to ensure accuracy.',
      'contact_support': 'Contact Support',
      'contact_message': 'Need more help? Contact our support team.',
      'email_support': 'Email Support',

      // Privacy Policy Screen
      'privacy_policy_title': 'Privacy Policy',
      'last_updated': 'Last Updated: January 2024',
      'information_collection': '1. Information We Collect',
      'information_collection_text':
          'We collect information you provide directly to us, including:\n• Account information (name, email)\n• Grant preferences and saved grants\n• Usage data and analytics',
      'information_use': '2. How We Use Your Information',
      'information_use_text':
          'We use the collected information to:\n• Provide and improve our services\n• Send grant notifications\n• Personalize your experience\n• Communicate with you',
      'information_sharing': '3. Information Sharing',
      'information_sharing_text':
          'We do not sell your personal information. We may share your data with:\n• Service providers who assist our operations\n• Legal authorities when required by law',
      'data_security': '4. Data Security',
      'data_security_text':
          'We implement appropriate security measures to protect your information from unauthorized access, alteration, or destruction.',
      'your_rights': '5. Your Rights',
      'your_rights_text':
          'You have the right to:\n• Access your personal data\n• Request data correction or deletion\n• Opt-out of communications\n• Export your data',

      // Terms of Use Screen
      'terms_of_use_title': 'Terms of Use',
      'acceptance': '1. Acceptance of Terms',
      'acceptance_text':
          'By accessing and using this application, you accept and agree to be bound by these Terms of Use.',
      'use_of_service': '2. Use of Service',
      'use_of_service_text':
          'You agree to use this service only for lawful purposes and in accordance with these terms. You must not:\n• Misrepresent grant applications\n• Attempt to gain unauthorized access\n• Interfere with the service operation',
      'grant_information': '3. Grant Information',
      'grant_information_text':
          'While we strive for accuracy, grant information is provided "as is". We recommend verifying details directly with grant issuers before applying.',
      'user_accounts': '4. User Accounts',
      'user_accounts_text':
          'You are responsible for:\n• Maintaining account security\n• All activities under your account\n• Keeping your information up to date',
      'intellectual_property': '5. Intellectual Property',
      'intellectual_property_text':
          'All content, features, and functionality are owned by us and protected by copyright and trademark laws.',
      'limitation_liability': '6. Limitation of Liability',
      'limitation_liability_text':
          'We shall not be liable for any indirect, incidental, or consequential damages arising from your use of the service.',
      'changes_terms': '7. Changes to Terms',
      'changes_terms_text':
          'We reserve the right to modify these terms at any time. Continued use constitutes acceptance of modified terms.',

      // About Screen
      'about_title': 'About',
      'version': 'Version',
      'app_description':
          'CanGrant helps you discover and apply for government grants in Canada. Our mission is to make grant opportunities accessible to everyone.',
      'our_mission': 'Our Mission',
      'mission_text':
          'To democratize access to government funding by providing a simple, centralized platform for discovering and tracking grant opportunities.',
      'features_title': 'Features',
      'feature_1': '• Comprehensive grant database',
      'feature_2': '• Real-time status updates',
      'feature_3': '• Personalized recommendations',
      'feature_4': '• Save and track applications',
      'contact_info': 'Contact Information',
      'contact_email': 'Email: support@cangrant.ca',
      'contact_website': 'Website: www.cangrant.ca',

      // Common
      'ok': 'OK',
      'cancel': 'Cancel',
      'yes': 'Yes',
      'no': 'No',
      'loading': 'Loading...',
      'error': 'Error',
      'success': 'Success',
    },
    'zh': {
      // Home Screen
      'discover_grants': '发现资助',
      'search_grants': '搜索资助...',
      'filter': '筛选',
      'no_grants_found': '未找到资助',
      'adjust_filters': '尝试调整您的搜索或筛选条件',

      // Grant Status
      'status_open': '开放',
      'status_closed': '关闭',
      'status_upcoming': '即将开放',

      // Grant Detail Screen
      'apply_now': '立即申请',
      'save': '保存',
      'unsave': '取消保存',
      'grant_details': '资助详情',
      'status': '状态',
      'deadline': '截止日期',
      'amount': '金额',
      'up_to': '最高',
      'issuing_body': '发放机构',
      'eligibility': '资格要求',
      'overview': '概述',

      // Filter Dialog
      'filter_grants': '筛选资助',
      'grant_status': '资助状态',
      'all_statuses': '所有状态',
      'open': '开放',
      'closed': '关闭',
      'upcoming': '即将开放',
      'eligibility_criteria': '资格要求',
      'all_eligibility': '所有资格',
      'reset': '重置',
      'apply_filters': '应用筛选',

      // Profile Screen
      'profile': '个人资料',
      'settings': '设置',
      'saved_grants': '已保存的资助',
      'notifications': '通知',
      'dark_mode': '深色模式',
      'language': '语言',
      'support': '支持',
      'help_center': '帮助中心',
      'privacy_policy': '隐私政策',
      'terms_of_use': '使用条款',
      'about': '关于',
      'sign_out': '退出登录',
      'signing_out': '正在退出...',

      // Language Screen
      'select_language': '选择语言',
      'english': 'English (US)',
      'chinese': '中文（简体）',

      // Saved Grants Screen
      'your_saved_grants': '您保存的资助',
      'no_saved_grants': '尚未保存任何资助',
      'save_grants_message': '您保存的资助将显示在这里',

      // Help Center Screen
      'help_center_title': '帮助中心',
      'faq': '常见问题',
      'question_1': '如何申请资助？',
      'answer_1': '点击任何资助卡片查看详情，然后点击"立即申请"跳转到官方申请页面。',
      'question_2': '如何保存资助以便稍后查看？',
      'answer_2': '在资助详情页面，点击"保存"按钮。您可以从个人资料中查看所有已保存的资助。',
      'question_3': '每个资助状态是什么意思？',
      'answer_3': '开放：目前接受申请\n关闭：不再接受申请\n即将开放：即将开放申请',
      'question_4': '资助信息多久更新一次？',
      'answer_4': '资助信息每天更新以确保准确性。',
      'contact_support': '联系支持',
      'contact_message': '需要更多帮助？联系我们的支持团队。',
      'email_support': '电子邮件支持',

      // Privacy Policy Screen
      'privacy_policy_title': '隐私政策',
      'last_updated': '最后更新：2024年1月',
      'information_collection': '1. 我们收集的信息',
      'information_collection_text':
          '我们收集您直接提供给我们的信息，包括：\n• 账户信息（姓名、电子邮件）\n• 资助偏好和已保存的资助\n• 使用数据和分析',
      'information_use': '2. 我们如何使用您的信息',
      'information_use_text':
          '我们使用收集的信息来：\n• 提供和改进我们的服务\n• 发送资助通知\n• 个性化您的体验\n• 与您沟通',
      'information_sharing': '3. 信息共享',
      'information_sharing_text':
          '我们不出售您的个人信息。我们可能与以下对象共享您的数据：\n• 协助我们运营的服务提供商\n• 法律要求时的法律机构',
      'data_security': '4. 数据安全',
      'data_security_text': '我们实施适当的安全措施，以保护您的信息免受未经授权的访问、更改或破坏。',
      'your_rights': '5. 您的权利',
      'your_rights_text': '您有权：\n• 访问您的个人数据\n• 请求更正或删除数据\n• 选择退出通信\n• 导出您的数据',

      // Terms of Use Screen
      'terms_of_use_title': '使用条款',
      'acceptance': '1. 接受条款',
      'acceptance_text': '通过访问和使用此应用程序，您接受并同意受这些使用条款的约束。',
      'use_of_service': '2. 服务使用',
      'use_of_service_text':
          '您同意仅将此服务用于合法目的并遵守这些条款。您不得：\n• 歪曲资助申请\n• 试图获得未经授权的访问\n• 干扰服务运营',
      'grant_information': '3. 资助信息',
      'grant_information_text': '虽然我们力求准确，但资助信息按"原样"提供。我们建议在申请前直接与资助发放机构核实详情。',
      'user_accounts': '4. 用户账户',
      'user_accounts_text': '您负责：\n• 维护账户安全\n• 您账户下的所有活动\n• 保持您的信息最新',
      'intellectual_property': '5. 知识产权',
      'intellectual_property_text': '所有内容、功能和功能性均由我们拥有，并受版权和商标法保护。',
      'limitation_liability': '6. 责任限制',
      'limitation_liability_text': '对于因您使用服务而产生的任何间接、附带或后果性损害，我们概不负责。',
      'changes_terms': '7. 条款变更',
      'changes_terms_text': '我们保留随时修改这些条款的权利。继续使用即表示接受修改后的条款。',

      // About Screen
      'about_title': '关于',
      'version': '版本',
      'app_description': 'CanGrant帮助您发现和申请加拿大政府资助。我们的使命是让每个人都能获得资助机会。',
      'our_mission': '我们的使命',
      'mission_text': '通过提供一个简单、集中的平台来发现和跟踪资助机会，使政府资金获取民主化。',
      'features_title': '功能',
      'feature_1': '• 全面的资助数据库',
      'feature_2': '• 实时状态更新',
      'feature_3': '• 个性化推荐',
      'feature_4': '• 保存和跟踪申请',
      'contact_info': '联系信息',
      'contact_email': '电子邮件：support@cangrant.ca',
      'contact_website': '网站：www.cangrant.ca',

      // Common
      'ok': '确定',
      'cancel': '取消',
      'yes': '是',
      'no': '否',
      'loading': '加载中...',
      'error': '错误',
      'success': '成功',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
