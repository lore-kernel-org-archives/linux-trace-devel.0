Return-Path: <SRS0=4mzf=QT=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15773C282C4
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D38B420700
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Feb 2019 17:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725916AbfBLREU (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 12 Feb 2019 12:04:20 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46537 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729694AbfBLREU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 12 Feb 2019 12:04:20 -0500
Received: by mail-wr1-f66.google.com with SMTP id l9so3475763wrt.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 12 Feb 2019 09:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9z+oR7jILbY40Vc1ovSYxahDUvdETkAVgYKvzAuYuzQ=;
        b=ObjlkYBSdJUH0RzbGB2MwuQeg8R7ozjwshvBAga/uIzJ0rT32iesPNo3kNS9ikGvHW
         LSdHXWaR+cff+hHCgMzYvQ0sNksNW691g3hIplcGm+pwU8K6MC+/NawhQ776cZYggyWZ
         m5wgy+pwc62wn0xNEG8Bc26yAYo5faHxxe3pHvGP5xD5MPyG3EvKTU3ZimTmlSse4Yg9
         wInZQCJ3lXgG6gcaL03He3t/MTU0I5KPADLTv6WGsPz6UFA5TTpzHjfZOs7zt87B1xzx
         +nKknBdZDfuKzbavdeWZcJsHaeJtlRf4mqOGSkREPiFbwcOxXxrzjhLiQX1+nStiK/l5
         KhXg==
X-Gm-Message-State: AHQUAuYRik5tSXDrA/Rc0RrUyXbqZ0NzG+j4d87J79DY2zNdq+LX9FXE
        Dr/DkuYk04G4vati2VezP3bzAQaU
X-Google-Smtp-Source: AHgI3IZPKj7lCulrvSVE0JK5G0qt4alKQsWVnF5OzzQY0qoj68helDatwnGpGSGCIIG/WUCYXZjItA==
X-Received: by 2002:adf:c18c:: with SMTP id x12mr3803184wre.152.1549991058787;
        Tue, 12 Feb 2019 09:04:18 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id c139sm5579732wmd.13.2019.02.12.09.04.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 09:04:18 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/5] The right click of the button deselects the marker
Date:   Tue, 12 Feb 2019 19:03:57 +0200
Message-Id: <20190212170402.10104-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This series of patches implements the feature requested in
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=202327


Yordan Karadzhov (5):
  kernel-shark: Customize the marker switching button
  kernel-shark: Define a method in View for selecting the Passive marker
  kernel-shark: Define KS_NO_ROW_SELECTED as a negative row index (-1)
  kernel-shark-qt: Do marker-deselect by right mouse click of the button
  kernel-shark: Rename the method for deselecting the Active marker.

 kernel-shark/src/KsDualMarker.cpp  | 21 ++++++++++++++
 kernel-shark/src/KsDualMarker.hpp  | 46 ++++++++++++++++++++++++++++--
 kernel-shark/src/KsMainWindow.cpp  | 38 +++++++++++++++++++++---
 kernel-shark/src/KsMainWindow.hpp  |  6 +++-
 kernel-shark/src/KsModels.cpp      |  8 +++---
 kernel-shark/src/KsModels.hpp      |  3 ++
 kernel-shark/src/KsTraceViewer.cpp | 22 ++++++++++++--
 kernel-shark/src/KsTraceViewer.hpp |  2 ++
 8 files changed, 132 insertions(+), 14 deletions(-)

-- 
2.17.1

