Return-Path: <SRS0=T0vY=QL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16418C282C4
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFD1B2081B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Feb 2019 07:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfBDHJE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Feb 2019 02:09:04 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36719 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfBDHJE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Feb 2019 02:09:04 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so2142224wrv.3
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Feb 2019 23:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=NizWEPNmX5axge9BdQSr1OwMV0+zdupHJpaVInlnmfo=;
        b=PSUpiuwavGjVKMnHh3AYiVu9WqiNQLR8AmMs+k1uQm95wFewwEPU9HrSSQNZAFRm05
         irX+AGRmpHjewIT6ThcaopCgNbOTrTL4xAU+iaUUjgxVSUqQEmhxcyi571ZiizCc55C3
         H5pkMdA6wdnLcgtJVvMKdKk17H+7JiGOrc8mL6uDLeGNZmlstygfbk53xYNxU17JvPo5
         4yibQCBn7rpCTS34AqUByTYZomEf1vAYDdYhsYb0nzQaECfoeZ78/beMtjNVqTnO5L2F
         DNDAqbZKqHD9zPBIOrYVuhId68xIXNAVkJHX23JVJMdoEUc2OjjCPpxT0DBnxh/VxEYg
         DmXA==
X-Gm-Message-State: AJcUukdL6nMytJIVyvb7aGWNLRFbP++u6z0wmCM4sCtw2AS3fJsxItbS
        HoKGo01UbY30K23xzFCowzeoD61TcQ==
X-Google-Smtp-Source: ALg8bN7HQtZH2dXG2tf2n96fwQ28VA7ajBMcdMrAvUr6NKyc3ZNu/YmESzZ6Bl7TgiExyCB1RzuJ/g==
X-Received: by 2002:adf:f390:: with SMTP id m16mr46241507wro.71.1549264141849;
        Sun, 03 Feb 2019 23:09:01 -0800 (PST)
Received: from localhost.localdomain ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id w12sm13222378wrr.23.2019.02.03.23.09.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Feb 2019 23:09:01 -0800 (PST)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, slavomir.kaslev@gmail.com,
        tstoyanov@vmware.com, ykaradzhov@vmware.com
Subject: [PATCH 0/8] trace-cmd protocol fixes
Date:   Mon,  4 Feb 2019 09:08:47 +0200
Message-Id: <20190204070855.8921-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patch set tries to make trace-cmd's protocol more robust to future
changes. New MSG_NOT_SUPP message is added for acknowledgement of unexpected
requests.

Slavomir Kaslev (8):
  trace-cmd: Remove unused global variable
  trace-cmd: Rename error_operation_for_server
  trace-cmd: Remove tracecmd_msg_handle/tracecmd_msg_server distinction
  trace-cmd: Check if connection is done when reading data in
    tracecmd_msg_read_data
  trace-cmd: Fix a memory leak in tracecmd_msg_send_init_data
  trace-cmd: Make tracecmd_msg_send_close return error code if any
  trace-cmd: Add tracecmd_msg_wait_close function
  trace-cmd: Acknowledge unexpected protocol messages

 include/trace-cmd/trace-cmd.h |  14 +--
 tracecmd/trace-listen.c       |   2 +-
 tracecmd/trace-msg.c          | 172 ++++++++++++++++++----------------
 tracecmd/trace-record.c       |   2 +-
 4 files changed, 96 insertions(+), 94 deletions(-)

-- 
2.19.1

