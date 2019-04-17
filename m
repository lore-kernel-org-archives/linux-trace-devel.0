Return-Path: <SRS0=58xy=ST=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBE42C282DA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC5F221773
	for <linux-trace-devel@archiver.kernel.org>; Wed, 17 Apr 2019 13:10:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730209AbfDQNKI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 09:10:08 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:56185 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726800AbfDQNKI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 09:10:08 -0400
Received: by mail-wm1-f67.google.com with SMTP id o25so3314234wmf.5
        for <linux-trace-devel@vger.kernel.org>; Wed, 17 Apr 2019 06:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CRu3vZodAro9mIpzE42LXAtQ286Tlh8xnLZwC5KW0ZU=;
        b=SaBmKCtxuFcKGZNlU1NJFW2pAZrhARuJVXChAv1gp838TRMYEbe0uoUT3MLL32lJmt
         IEclRBZGZlhv7S4zSJC5XgOH/MFmQEpkjiaB5/puUyyTt7AvZ7f996HsTnsj7v/C/4vz
         nMgQqFYaKBK180UkFeRchNUjJPXYERcbHjAlCxjadYkDuhhGiaEG3V5JJODihUZDP/3K
         sSdVGmwoiJ7mXfinjGGrI9vSuB0L63XZxeza9/HTIDnmmXUc/p/OahMAItnE7IdTcezc
         Ayyedw2f1/U6NLkOciDS3LbROf+jX06ZulS8IT1PEg6AB1L+qnHwaKruRkv5QM6SNI8p
         OLkA==
X-Gm-Message-State: APjAAAXT52p9tJomW6NEF3O9rDsb3zfVa1hfB+0cBEIBxaAes+MDkGvZ
        V6fnPuZ+t6QLYamX7eegPw==
X-Google-Smtp-Source: APXvYqyl2/WdXtQ0bTN+uz9eM13mUHdXfK0MeQeME0Tv4xuzmR0jZTdveDGdEQDiaN8ANKv0ypu+mg==
X-Received: by 2002:a7b:c4d5:: with SMTP id g21mr30141850wmk.133.1555506606459;
        Wed, 17 Apr 2019 06:10:06 -0700 (PDT)
Received: from localhost.localdomain ([151.251.252.188])
        by smtp.gmail.com with ESMTPSA id d16sm48124303wrs.68.2019.04.17.06.10.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 06:10:05 -0700 (PDT)
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org, pauld@redhat.com,
        ykaradzhov@vmware.com, jbacik@fb.com, tstoyanov@vmware.com,
        slavomir.kaslev@gmail.com
Subject: [PATCH v4 0/2] Optimize pid filters
Date:   Wed, 17 Apr 2019 16:09:57 +0300
Message-Id: <20190417130959.10064-1-kaslevs@vmware.com>
X-Mailer: git-send-email 2.19.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This patchset optimizes how pid filters are expressed and makes it less likely
that we overflow ftrace filters' size limit of one page.

Changes since v3:
Addressed Steven's review feedback
Add section about --no-filter to `trace-cmd record`'s man page
Dropped the patch adding --no-filter since Steven has already applied it

Changes since v2:

Append exclude rules with &&

Changes since v1:

Add missing tags
Fix append_filter_pid_range() callers to pass valid range as [min,max]

Slavomir Kaslev (2):
  trace-cmd: Optimize how pid filters are expressed
  trace-cmd: Document record --no-filter option in record's man page

 Documentation/trace-cmd-record.1.txt |   4 +
 tracecmd/trace-record.c              | 117 ++++++++++++++++++---------
 2 files changed, 85 insertions(+), 36 deletions(-)

-- 
2.19.1

