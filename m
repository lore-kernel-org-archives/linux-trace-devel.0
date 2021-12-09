Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1E6C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Dec 2021 10:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhLIKtL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Dec 2021 05:49:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbhLIKtL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Dec 2021 05:49:11 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF9CC061746
        for <linux-trace-devel@vger.kernel.org>; Thu,  9 Dec 2021 02:45:38 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id t5so18264441edd.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Dec 2021 02:45:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BVPygrDF/6zpicnDp61Gfcn8gqDeNYnsqDs9D3KkGs=;
        b=Gke6gMSA+6JQTgE141Fc4gIugbSogb1e25HV4Zspv5C+EI7++N/ibXlGg0vGeI0kUR
         jTuvchHp4uEHwEnUthWtdy9sOfIVyO1AjeH4jBhL/yRS3mAfFy8Im+7Y0dsT+UYCGX0J
         T65HLWQlqneUJDRiofd6OLxDUHQRm/Es1wnF8AVgU0Ly7KDFW18H18dhi7SG7IDKuKzm
         2pjXW9QpjCE+82/OM1iugss8IK/RhM/30Q1MQv+EGCgtaVq8xef4IfiwHNWjdgFCHJdJ
         5Sdt79mj+uvlHOHmAOPFIpA/FQODrrBsyY71Rog+Dnx1xwe5ili0/8T/9b+piwLBJVYj
         T/8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2BVPygrDF/6zpicnDp61Gfcn8gqDeNYnsqDs9D3KkGs=;
        b=f56Syrq+6+OH+4kWOKM6tcPPKl/L1BB52hF1s5kKjZUgeK7h9BpM1tecxP3eidgZK9
         uFiyLKH7sRC9ODohMD6h10haWVJoQUNW5A8c6RJrHee50HXYIuZ9973Jt3T5veeqmgHF
         ajUszeyhv2rKT3Ew3uRfW6VNQLzerNqSSyE0DZx5oCG5FVL/KvgR2I6w12jmcCkGpg1u
         39gGWA7aYyEuJ3aziH3+zI64QcR8iTX5ocX4T0viz8Jib10wAp/IPKDIjxjv640F4C2H
         sf7y5OBptzOi5dbBZdQNuvv5Gj239hWkMeNk/tuddq5Udkb0ACLqO0ZPDxpS1trT9rhq
         sgrw==
X-Gm-Message-State: AOAM530qQEi/DdeAnmcY2iyRAeXKvMqm+yjAkjeZ5NxHFR4wXOVuzt5W
        1wvVIWkd3rEdLIZYpSDJNt4=
X-Google-Smtp-Source: ABdhPJxGEyLMz2I5j5LclR7/7Nkjo7aEpK48GW2O1+J1G5US7usVZqOnfD2XU6btmusP4Ld0NzgAcQ==
X-Received: by 2002:a17:907:dab:: with SMTP id go43mr14394498ejc.537.1639046735966;
        Thu, 09 Dec 2021 02:45:35 -0800 (PST)
Received: from crow.. ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id b7sm3778545edd.26.2021.12.09.02.45.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Dec 2021 02:45:35 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Cc:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v2 0/3] libtracefs: APIs for inspecting hist/synth objects
Date:   Thu,  9 Dec 2021 12:45:21 +0200
Message-Id: <20211209104524.5354-1-y.karadz@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Changes in v2:
 - Dropping patch 'libtracefs: New API for getting the raw format of a
   histogram'. This patch must be redesigned.

 - Adding patch 'libtracefs: New APIs for getting the raw format of
   synth event'.

 - Number of fixes suggested by Steven in his review.


Yordan Karadzhov (VMware) (3):
  libtracefs: Rename the 'tracefs_get_hist_*()' APIs
  libtracefs: Add new API for getting synth event name
  libtracefs: New APIs for getting the raw format of synth event

 Documentation/libtracefs-hist.txt   |  24 ++++-
 Documentation/libtracefs-synth2.txt |  14 ++-
 include/tracefs.h                   |  12 ++-
 src/tracefs-hist.c                  | 132 +++++++++++++++++++++++-----
 4 files changed, 154 insertions(+), 28 deletions(-)

-- 
2.32.0

