Return-Path: <SRS0=14DL=SR=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76B47C10F0E
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44C632084B
	for <linux-trace-devel@archiver.kernel.org>; Mon, 15 Apr 2019 23:00:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfDOXAY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 19:00:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37019 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbfDOXAY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 19:00:24 -0400
Received: by mail-wm1-f66.google.com with SMTP id v14so22505099wmf.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 15 Apr 2019 16:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/XseML3ofOQOv9TlK6jGuxCK8FcUHLbkd90q+mU+NDA=;
        b=k08BhGCYjAR7q8xRhryxJA6dvqiCUkyno5YDxr9KxLsdctytnpQD/4JGZT4cDc6vgh
         83HVc/Sg+o3IwveisxW9SEsI/TW5DWYI5G3+Baaw4Vt/FFzXBoqZR4XRdaBW5FaQEOon
         H1+TV5Z9Wp1jOEJKGyoagg/BjQ6vmb3hsyFsSZ4au813ftr7LzfTQGJWzuHw7ZHpmHjw
         7uREAMzx1mxagcRFuVl4mHSZvxRhraYHZbYKi5nlIpmo5QEzpmti3fr5fv0DMSvzlUkQ
         3DZW6wEIpVLDKaYHU+i4AnuGFKq/IPOC2Tu8+AHWuywxh0X5O0w8zE/BkyTYm/G+8S3f
         WcvA==
X-Gm-Message-State: APjAAAXFsS9P8HXlXoDtTX7AOSe3GmcZP+xN2qf0wuuwNFxvtlKDhD9y
        ZJedmCQmi3RVOVnf3PoAOQ==
X-Google-Smtp-Source: APXvYqwhp2NSmAe3f992q1Dufxpk1khTm2oKsP1M3Ls+WNZpGrs6mMiL8F9VnpIb1Kx1wBorpWyoHw==
X-Received: by 2002:a1c:5588:: with SMTP id j130mr23648459wmb.72.1555369223017;
        Mon, 15 Apr 2019 16:00:23 -0700 (PDT)
Received: from localhost.localdomain ([151.251.250.145])
        by smtp.gmail.com with ESMTPSA id v184sm36426455wma.6.2019.04.15.16.00.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Apr 2019 16:00:21 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v3 0/2] Optimize pid filters and add --no-filter option
Date:   Tue, 16 Apr 2019 02:00:14 +0300
Message-Id: <20190415230016.13932-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset optimizes how pid filters are expressed and makes it less likely
that we overflow ftrace filters' size limit of one page.

Changes since v2:

Append exclude rules with &&

Changes since v1:

Add missing tags
Fix append_filter_pid_range() callers to pass valid range as [min,max]


Slavomir Kaslev (2):
  trace-cmd: Optimize how pid filters are expressed
  trace-cmd: Add --no-filter option to not filter recording processes

 tracecmd/trace-record.c | 131 ++++++++++++++++++++++++++++------------
 tracecmd/trace-usage.c  |   1 +
 2 files changed, 92 insertions(+), 40 deletions(-)

-- 
2.19.1

