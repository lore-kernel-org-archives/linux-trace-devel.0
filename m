Return-Path: <SRS0=BXa2=RQ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51CB8C43381
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 288DC214AE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Mar 2019 15:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725895AbfCMPHk (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Mar 2019 11:07:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35501 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCMPHk (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Mar 2019 11:07:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id y15so2270545wma.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Mar 2019 08:07:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jyFccVLWzuY8/KMA6mJbr/szyCOl1142wMOSFppIxFs=;
        b=eBSk+In2/8s9RuXk9B61eO5ywxQA2jHYI/Ug16/NeQyMFNccg6CXJcguYY5iAWZpQS
         WZXN8hbKMS0OZUAfEKi+wtXX6lkqKsWW06hPQb6hbyIhz18q8xmWEwgcJaK314i72ihv
         KF2+VQw5qjg6+CeDO7rigdBxq+LM97sdHcMJykNbMt2EEQVbXzJ7HMQQXWHujA1ycDti
         X50Yj6YYPYeQziYay0t9DjUBx/xhzRAH1GWjTY1KT1ta1up3b9/H5FYGU57zikMsxocZ
         jQImSiqDfCOBCJ//3GGXwxknon9cFQQKzjZfdBP/nFDndpf9LMzHR5Oj4OWEqenpi95U
         YqVw==
X-Gm-Message-State: APjAAAVNx4x1LPZP5u0mZb5u+6prlNcTufAa17vVaW8Yz9toJt68q15T
        DpzdR2tNxSFOMQx9ODTLVAw=
X-Google-Smtp-Source: APXvYqyetnuWkzCyPO5GGCTt79gi1ft6MPgOY2JY0GZSB+04cU4ZnYTxAhtn8S5lJa0BYWIvKmmp4w==
X-Received: by 2002:a1c:7903:: with SMTP id l3mr2801028wme.22.1552489658822;
        Wed, 13 Mar 2019 08:07:38 -0700 (PDT)
Received: from localhost.localdomain ([95.87.198.56])
        by smtp.gmail.com with ESMTPSA id f6sm22515103wrs.45.2019.03.13.08.07.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Mar 2019 08:07:38 -0700 (PDT)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH v2 0/4] Add dialog for loading user-defined plugins
Date:   Wed, 13 Mar 2019 17:07:13 +0200
Message-Id: <20190313150717.21345-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

So far loading user-defined plugins was possible only from the
command line

./kernelshark -p /path/to/your/plugin-lib.so

This patch set adds the possibility to load plugins from the GUI
itself by using a dedicated dialog available in Tools

Changes in v2:
  - The dialog can now select and load multiple plugins at a time, as
suggested by Slavomir and Steven .

  - After re-initializing the list of plugins the data is reloaded.
Not reloading the data was a bug in the previous version.

Yordan Karadzhov (4):
  kernel-shark: Define addPlugins method for KsPluginManager
  kernel-shark: Add dialog for user-defined plugins to the Tools menu
  kernel-shark: Rename the manu action for managing registered plugins
  kernel-shark: Add icons for "Add plugins" and "Manage plugins"

 kernel-shark/src/KsMainWindow.cpp | 34 ++++++++++++++++++++++++++-----
 kernel-shark/src/KsMainWindow.hpp |  6 +++++-
 kernel-shark/src/KsUtils.cpp      | 23 +++++++++++++++++++++
 kernel-shark/src/KsUtils.hpp      |  3 +++
 4 files changed, 60 insertions(+), 6 deletions(-)

-- 
2.19.1

