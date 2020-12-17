Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C30D0C4361B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71803233FB
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Dec 2020 09:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgLQJrL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Dec 2020 04:47:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727739AbgLQJrK (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Dec 2020 04:47:10 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E8BC061794
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:29 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t30so7861833wrb.0
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Dec 2020 01:46:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MzZUj5SHQxWPLsQd3l44Qno/M2zOAlRQjHJyeFYAaJw=;
        b=QN/w4IrrQf1qehyP7SFkEvp9OWnyaEpMXLzrYEGEty2v68YAqzhzFvHRjzqSTuBKZZ
         snCSdcBeEi3Tqc2Acml0iTadFj/38tMROMBgnvol+dOoUpYdFQ3e/uD5BnYv99IhYjAQ
         UsBW50rWyKDX1YSpdFxgxihTRMkJ0PU0NblnQD6wfN0MUaxvtTIFeu7r2mwk5E8n8d06
         z9IElG1FKumZ440Hnk0/NN/eTvl/JjlcRNAUhK871plIYyr/XUA/rwEUls9R5r1mbsjX
         c9Z+BmsELii3TDjcdYH64CjwDIZvRm9HwFqND6sOQ7ET6mw7zjpeweGB7Qr3hsea7Afz
         fsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MzZUj5SHQxWPLsQd3l44Qno/M2zOAlRQjHJyeFYAaJw=;
        b=OcyyvRCLO/pXHAvTuDsOCa94ToQEcRL+LZmbDcGNvjxoW1KwukOFI/avjbAzYzDdT3
         zktOTXztWcq4PhlSLRbpQvSxuoZUrwcjPbhgVbq0Gd9TOKft177RenTwpCdIDiNOxyc9
         Cl1kCeJJRqn6mZF6zcHdLrohHzjEeE/SH9JGyEDcecO/AmQLZmEo6KF8l/RZqgpUOc25
         X+9oWxfQyZuhZAGlyVCqjaqZxpOU/N6bNaae5CbT6k1swE4xdAObZ5xSwqeCve848KSx
         XaYNdMgIy7l6I04N/QCn5P+7bEL18YA0YDMuAe7Y4gnMctzyZ5gUTE8BlkXtwre/q8PP
         uCXg==
X-Gm-Message-State: AOAM531jwEvV70DjSLCYA2+qWKSsvW8UHo+LGIHxG14LGI/zPna+nbGJ
        22DerzWjxhB/Ut8tsTsoMvBBig/T57ffeA==
X-Google-Smtp-Source: ABdhPJy2dhcbsapDpXwx/RBdclyfLoNow01AAWS73KSCJijKtzJ9ZnCiv/U/kZDqL8KnAXfw8uPkmQ==
X-Received: by 2002:adf:ba46:: with SMTP id t6mr43024681wrg.168.1608198388495;
        Thu, 17 Dec 2020 01:46:28 -0800 (PST)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id o125sm6773164wmo.30.2020.12.17.01.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 01:46:27 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/9] libtracefs man pages
Date:   Thu, 17 Dec 2020 11:46:17 +0200
Message-Id: <20201217094626.1402191-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Initial implementation of libtracefs man pages.

Tzvetomir Stoyanov (VMware) (9):
  libtracefs: Remove doc_gui targets
  libtracefs: Initial support for man pages
  libtracefs man pages: APIs for locating trace directory and files.
  libtracefs man pages: APIs for working with trace systems and events.
  libtracefs man pages: APIs for managing trace instances.
  libtracefs man pages: APIs for working with files in trace instances.
  libtracefs man pages: helper APIs for working with trace instances.
  libtracefs man pages: APIs for initializing a tep handler with trace
    events from the local system.
  libtracefs man pages: helper APIs for working with trace file system.

 Documentation/Makefile                        | 211 ++++++++++++++++++
 Documentation/asciidoc.conf                   | 120 ++++++++++
 Documentation/libtracefs-events-tep.txt       | 131 +++++++++++
 Documentation/libtracefs-events.txt           | 140 ++++++++++++
 Documentation/libtracefs-files.txt            | 111 +++++++++
 Documentation/libtracefs-instances-files.txt  | 157 +++++++++++++
 Documentation/libtracefs-instances-manage.txt | 104 +++++++++
 Documentation/libtracefs-instances-utils.txt  | 111 +++++++++
 Documentation/libtracefs-utils.txt            | 103 +++++++++
 Documentation/libtracefs.txt                  |  86 +++++++
 Documentation/manpage-1.72.xsl                |  14 ++
 Documentation/manpage-base.xsl                |  35 +++
 Documentation/manpage-bold-literal.xsl        |  17 ++
 Documentation/manpage-normal.xsl              |  13 ++
 Documentation/manpage-suppress-sp.xsl         |  21 ++
 Makefile                                      |   9 -
 16 files changed, 1374 insertions(+), 9 deletions(-)
 create mode 100644 Documentation/Makefile
 create mode 100644 Documentation/asciidoc.conf
 create mode 100644 Documentation/libtracefs-events-tep.txt
 create mode 100644 Documentation/libtracefs-events.txt
 create mode 100644 Documentation/libtracefs-files.txt
 create mode 100644 Documentation/libtracefs-instances-files.txt
 create mode 100644 Documentation/libtracefs-instances-manage.txt
 create mode 100644 Documentation/libtracefs-instances-utils.txt
 create mode 100644 Documentation/libtracefs-utils.txt
 create mode 100644 Documentation/libtracefs.txt
 create mode 100644 Documentation/manpage-1.72.xsl
 create mode 100644 Documentation/manpage-base.xsl
 create mode 100644 Documentation/manpage-bold-literal.xsl
 create mode 100644 Documentation/manpage-normal.xsl
 create mode 100644 Documentation/manpage-suppress-sp.xsl

-- 
2.28.0

