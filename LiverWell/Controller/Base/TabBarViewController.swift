//
//  TabBarViewController.swift
//  LiverWell
//
//  Created by 徐若芸 on 2019/4/3.
//  Copyright © 2019 Jo Hsu. All rights reserved.
//

import UIKit

private enum Tab {

    case home

    case activity

    case knowledge

    case profile

    func controller() -> UIViewController {

        var controller: UIViewController

        switch self {

        case .home: controller = UIStoryboard.home.instantiateInitialViewController()!

        case .activity: controller = UIStoryboard.activity.instantiateInitialViewController()!

        case .knowledge: controller = UIStoryboard.knowledge.instantiateInitialViewController()!

        case .profile: controller = UIStoryboard.profile.instantiateInitialViewController()!

        }

        controller.tabBarItem = tabBarItem()

        return controller

    }

    func tabBarItem() -> UITabBarItem {

        switch self {

        case .home: return UITabBarItem(
            title: "首頁",
            image: UIImage.asset(.Icon_24px_Home_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Home_Selected)
            )

        case .activity: return UITabBarItem(
            title: "動一動",
            image: UIImage.asset(.Icon_24px_Workout_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Workout_Selected)
            )

        case .knowledge: return UITabBarItem(
            title: "肝好知識",
            image: UIImage.asset(.Icon_24px_Knowledge_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Knowledge_Selected)
            )

        case .profile: return UITabBarItem(
            title: "我的",
            image: UIImage.asset(.Icon_24px_Profile_Normal),
            selectedImage: UIImage.asset(.Icon_24px_Profile_Selected)
            )
        }

    }

}

class TabBarViewController: UITabBarController {

    private let tabs: [Tab] = [.home, .activity, .knowledge, .profile]

    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = tabs.map({ $0.controller() })
    }

}
