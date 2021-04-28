Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BCCBC433ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5FCD606A5
	for <linux-trace-devel@archiver.kernel.org>; Wed, 28 Apr 2021 07:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236872AbhD1HrW (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 03:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhD1HrU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 03:47:20 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99436C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:33 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id u3so14496649eja.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 28 Apr 2021 00:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wSKAIS67Tmb3zPLziKAfFpKAhZ4dyITEq7ibrirHf0=;
        b=t3NcEC6UKcbsXMOKBCp2ponM8vUY2f/ASZX3hp3vcuNobgZewhSKsSap6fbfsP74Hh
         i52DMkOwD9c46GAyQkhoh8OHDT3pm03zgKobqRvedgs5y5/yf5C1DnlWqTGZ9tZ4XOLC
         kfofev7iLQOVu7KEWT6HHjdkYBjHZ+N6/lYE+zsgDmLfHl7uwmGv6eZy8p1uuU2VffHd
         kr/c/AihKwDnmYVQfhIz18U0Qs5l50a+fEsUTFCBzuTFzc3GgEyLGkSPft64Cob3wBc4
         qMMeq6Ei8pSzZe8JxiQuZM1vwE05Bp5u4/z7CxpP+2f853UJ85LXK80YnWGZUhTzjPbI
         lGCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4wSKAIS67Tmb3zPLziKAfFpKAhZ4dyITEq7ibrirHf0=;
        b=BT09548Pjda2XYA/v9PfKbS/11teApnkec3+tfkvO2sXcmcbIIvPJrSNiIWkkcG368
         BMPIi35eLFJGrM5j3CWa4/pq1utxBDh4rZmZC0JTDl0fCfVEaZsVddbeWwVERYz2ycRB
         hHGYguKjoWQospdGDJ30HJGprL7346UAy4dqtX6Mkg/1RGLcD0qL/We21FFxyePFSDZS
         wkW7zo+X7/LdMkWfSK052fwaIYLGsQVEKPTMI4UglT8vpfsiYxxsnpoJmn4D2C17rDDL
         ejTCYjSGo1VET9tBLvuAlWkKW5CDoGDwUWV9R6fXJmTw2Sxel+qM8q01PI2jWpB7kNFi
         xJjQ==
X-Gm-Message-State: AOAM530NcPTTZuWPWzoeq6MU/q5kYQIVkrXaMF0YqD/9Hr5XI862cipA
        J+KdfHNUmqPow8aEhmuc6zI=
X-Google-Smtp-Source: ABdhPJxqbd8nq7mwBafqxlH9+W1egv407mCJ27RLS4YooGrOAFnP6YiOV74hKwWdU6bkvyRmbpvmpA==
X-Received: by 2002:a17:906:6d48:: with SMTP id a8mr28059462ejt.92.1619595992386;
        Wed, 28 Apr 2021 00:46:32 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id lc1sm1412556ejb.39.2021.04.28.00.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 00:46:31 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/7] Add --verbose option to bunch of trace-cmd commands
Date:   Wed, 28 Apr 2021 10:46:23 +0300
Message-Id: <20210428074630.757694-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

A new option to set log severity is added to these trace-cmd commands:
 report, agent, check-events, listen. stack, dump, start, set, extract,
 stream, profile, record

These changes depend on "[PATCH 0/8] Changes to trace-cmd logs"
https://lore.kernel.org/linux-trace-devel/20210428074149.757163-1-tz.stoyanov@gmail.com/

Tzvetomir Stoyanov (VMware) (7):
  trace-cmd report: Add --verbose
  trace-cmd agent: Add --verbose
  trace-cmd check-events: Add --verbose
  trace-cmd: Add --verbose to bunch of trace-cmd commands
  trace-cmd listen: Add --verbose
  trace-cmd stack: Add --verbose
  trace-cmd dump: Add --verbose

 .../trace-cmd/trace-cmd-check-events.1.txt       |  9 +++++++++
 Documentation/trace-cmd/trace-cmd-dump.1.txt     |  8 ++++++++
 Documentation/trace-cmd/trace-cmd-extract.1.txt  |  8 ++++++++
 Documentation/trace-cmd/trace-cmd-listen.1.txt   |  8 ++++++++
 Documentation/trace-cmd/trace-cmd-profile.1.txt  |  9 +++++++++
 Documentation/trace-cmd/trace-cmd-record.1.txt   |  9 +++++++++
 Documentation/trace-cmd/trace-cmd-report.1.txt   |  9 +++++++++
 Documentation/trace-cmd/trace-cmd-set.1.txt      |  9 +++++++++
 Documentation/trace-cmd/trace-cmd-stack.1.txt    |  4 ++++
 tracecmd/trace-agent.c                           |  6 ++++++
 tracecmd/trace-check-events.c                    | 16 +++++++++++++++-
 tracecmd/trace-dump.c                            |  6 ++++++
 tracecmd/trace-listen.c                          |  6 ++++++
 tracecmd/trace-read.c                            |  6 ++++++
 tracecmd/trace-record.c                          |  6 ++++++
 tracecmd/trace-stack.c                           |  6 ++++++
 tracecmd/trace-usage.c                           | 12 ++++++++++++
 17 files changed, 136 insertions(+), 1 deletion(-)

-- 
2.30.2

