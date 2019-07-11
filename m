Return-Path: <SRS0=ayt5=VI=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F23DC74A52
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 485FD21019
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Jul 2019 13:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S4d/ba+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfGKNDM (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 09:03:12 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46668 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfGKNDM (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 09:03:12 -0400
Received: by mail-wr1-f68.google.com with SMTP id z1so6177257wru.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Jul 2019 06:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PnD2zAR97RZl8exI0FV7DqKepzYsBIJgU9zI5KzQPI=;
        b=S4d/ba+3u+hXB3B1VGLkrcyDO4fNbpKKcMYAQozJYgYidUAxtxfBoEG9m/ZJnmW/Zw
         QNhcvlpjiLEbgT3kvRpCxrhklKj0o9yus9BSKduEYiaOgPVnFSGZdeaSZF7hIe+YC6ai
         bmjDn45LOkPI8X29aVntiqKlErBOMYgpqx2fsUZPWIGmMiq8NAf/PZyKhvkn8Yo8CtoJ
         Mzlr/ejFU//7DPTN/XsM/rZspm6jLEA14ARiamy0DTeGRkSSOzFaBtWtP1gdfXh0YGoK
         c/oWowQpSji7BYhQZnN7oSgds4rcaQnEKo2vfE5frNSCvuVl30RieiULMYK7Avqy6ac8
         rFyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7PnD2zAR97RZl8exI0FV7DqKepzYsBIJgU9zI5KzQPI=;
        b=G6x/ueh2Id35oPhTT8Nd6BC8g8VQZ6ySxoLYbyxrrOwmnsFM5lBKZ2nuasE+DudEhZ
         t8CcNNxR7bh5jwLLR1ZEdtYBkIfqj8HEaWpDQJuEUWzV0PHUliKtT/+KIGDWcTsY989s
         /hWqtJsF8DE+zugilTJnXopH3+WMvVvShM1wQamsApuocf7ZgbZC/BokdMvqbClVzzbV
         ZreUhKRlxN24dw5G7vr7V5fjUCh7EBS/ExjCw38SWsD1N1+HibN3rYMrjlDbhiHfZY3F
         Z153gQ0mmAzE7wREWegSklVjPAt9Kshd5523CFfmy8dX8h/Y3jHK52qJ9KYPO8eL/PzS
         BoCQ==
X-Gm-Message-State: APjAAAV2/toLR4v6Cb7P7SoEUYY0lx174jmg421XGaXKiCejqkDeRXwa
        o2klOK3B19d7i7UYzKNU5bmo59Wq
X-Google-Smtp-Source: APXvYqyTLsflL8jLfQq9I4gFlqN49/TLubWQB7poj/lieDgenXjzX+RmRTcaS1MXTnxmjjpMhbifkw==
X-Received: by 2002:adf:e444:: with SMTP id t4mr4984996wrm.262.1562850190678;
        Thu, 11 Jul 2019 06:03:10 -0700 (PDT)
Received: from oberon.eng.vmware.com ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id h6sm4642590wre.82.2019.07.11.06.03.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 06:03:09 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/7] Separate trace-cmd and libtracecmd code
Date:   Thu, 11 Jul 2019 16:03:00 +0300
Message-Id: <20190711130307.25041-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtracecmd is a library, containing functions that can be
used without trace-cmd application. However, some of the
functions declared as libtracecmd APIs in trace-cmd.h
depend on trace-cmd context. That causes a problem when
other application uses the library. The problem can be
observed when running kerneshark and there is a python
module, loaded by the python plugin - there is a bunch
of warnings.
To resolve the problem, implementations of all trace-cmd
independent functions are moved into libtracecmd. All
libtracecmd functions, that depend on trace-cmd context
are removed from the library and from trace-cmd.h file.

Tzvetomir Stoyanov (VMware) (7):
  trace-cmd: Move trace-output.c into the library code
  trace-cmd: Move trace-msg.c into the library.
  trace-cmd: Move trace-cmd global variable "quiet" to libtracecmd
  trace-cmd: Move trace-cmd global variable "debug" to libtracecmd
  trace-cmd: Move plog() function to libtracecmd.
  trace-cmd: Move trace-cmd APIs from trace-cmd.h to trace-local.h
  trace-cmd: Move tracecmd_stack_tracer_status() function to libtracecmd

 include/trace-cmd/trace-cmd.h                 |  19 +-
 .../include => include/trace-cmd}/trace-msg.h |   3 -
 lib/trace-cmd/Makefile                        |  12 +-
 {tracecmd => lib/trace-cmd}/trace-msg.c       |   4 +-
 {tracecmd => lib/trace-cmd}/trace-output.c    |   4 +-
 lib/trace-cmd/trace-util.c                    | 162 ++++++++++++++++++
 tracecmd/Makefile                             |   2 -
 tracecmd/include/trace-cmd-local.h            |   2 -
 tracecmd/include/trace-local.h                |  14 +-
 tracecmd/trace-cmd.c                          |   3 -
 tracecmd/trace-list.c                         |   2 +-
 tracecmd/trace-listen.c                       |  77 ++-------
 tracecmd/trace-read.c                         |   8 +-
 tracecmd/trace-record.c                       |   8 +-
 tracecmd/trace-stack.c                        |  56 +-----
 15 files changed, 221 insertions(+), 155 deletions(-)
 rename {tracecmd/include => include/trace-cmd}/trace-msg.h (79%)
 rename {tracecmd => lib/trace-cmd}/trace-msg.c (99%)
 rename {tracecmd => lib/trace-cmd}/trace-output.c (99%)

-- 
2.21.0

