Return-Path: <SRS0=APAm=Q4=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27446C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF5F020855
	for <linux-trace-devel@archiver.kernel.org>; Thu, 21 Feb 2019 12:42:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725991AbfBUMmR (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 07:42:17 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:42189 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfBUMmR (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 07:42:17 -0500
Received: by mail-wr1-f68.google.com with SMTP id r5so16509920wrg.9
        for <linux-trace-devel@vger.kernel.org>; Thu, 21 Feb 2019 04:42:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=hlhKWelsOBYachGcYcsN9HrZZiu5m42zoc6h6NBaB5s=;
        b=KB5hY2KA/F13co+0mAJqOR0fP4c7zDJMOg5IVRLhy4YrNA25/oJrj/Grp86W+TrrPR
         luSoKcPpzm6EXf2dHDvJplDAXqJdoGRuMhf7XZdGeN5V9bax+CnhpO9poU6bPn6UZkRa
         aj1a/9qRMcAwbtYWPI0cThyQjawqleNHBTSSoLxjLO2Q82E930KO/kJHct0eJF8Mp4JK
         gGRuR6ZV1LxBhVJieErXET4z+NT/8aJ9T+sXbNttVUgwbg8T+lcVoy+j4RJPAV8mcu8/
         ssNVe1jDlQHuhm5oC48IaIv0HSSSn4KWlJKUgDTGHHJzYpH5sYJextfmok++IFUCgXzF
         eUTg==
X-Gm-Message-State: AHQUAuaSmDre2kTqRgkw0XsNXghLY5hSGDbCyAoAaax8IhebX+dsPLdX
        NS5Ijp77vOJ5o6GRD71HY1s=
X-Google-Smtp-Source: AHgI3Ia46En8H3ThoWJnXuUU1vg/uaCFhAjopFlVS0VADs2SW6/g7MP48qbghychVsVeHp+YTGvnjw==
X-Received: by 2002:a05:600c:21d9:: with SMTP id x25mr10665487wmj.136.1550752935894;
        Thu, 21 Feb 2019 04:42:15 -0800 (PST)
Received: from mamba.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id b4sm1359517wrr.64.2019.02.21.04.42.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Feb 2019 04:42:15 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 0/3] KernelShark visualization model fixes
Date:   Thu, 21 Feb 2019 14:42:02 +0200
Message-Id: <20190221124205.21115-1-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch set fixes three distinct, but strongly entangled bugs in the
visualization model of KernelShark. Most of the time those bugs have no
effect, but in some very rare cases may cause some of the sanity checks
of the model to fail.


Yordan Karadzhov (3):
  kernel-shark: Fix a bug in ksmodel_shift_backward()
  kernel-shark: Fix a bug in shift_XXX methods of the visualization
    model
  kernel-shark: Fix a bug in ksmodel_set_next_bin_edge()

 kernel-shark/src/libkshark-model.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

-- 
2.17.1

