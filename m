Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D008C433EF
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2314161252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:08:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233799AbhKKPK6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhKKPK6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:10:58 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C2AC061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id b15so25179800edd.7
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:08:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j1IS1ixSPRLJBrIqlTY+F4yC6dLG6JFOtDs7B5CmZls=;
        b=p1+axb2iA/x8dSAURoBu84sbplNwo73bPBrNkIZNsM71yhQNnJ0dQOOhdUFuqkjS9T
         3Jo8tXto5ExYwlSPXpJ0DEcBcwXMOW1+blcqI3/YveihPtlDWx7OshNYgwvkRGVCKsvI
         ohaCSzyxitAl2RYw7Bi8AIda2xqUHZvEqvgVpNh4ZusOUCm/8F4WsSBwVVgs/ABa2pbZ
         dVeCU5bzHDjSZWohQxvLis39PoLB52g19RRLPmPHO9RR5TpfdWAlFBUKok0hQBXIp0zF
         j55yY5rtwVHyh0OJUYE00g9ImBQuTAVm3BTPoBZErfh7qoDbD6c/2n8fi+TTB0j+/rRP
         plWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j1IS1ixSPRLJBrIqlTY+F4yC6dLG6JFOtDs7B5CmZls=;
        b=dxkEyOHjfEZ1hp8YKkI4jG/P8Kpfjzj92fA6yUXvuSFjD19ln84Zuy4B9NaxofWsL7
         CBn6LPy/+TugjhjlsvEdT2RWgfTXeBU7UDSqOWC/dbwXn6JRCcpflvOtPg3qGHQz8DhF
         3eiXJcsTIQwoxUcn6SEXHynusOq8bt0AIdxZzfvO3zWKxIiXsRlwt5MW1QLUX+nGp9EJ
         k2cLN1NwAv5RmX2DN9gnXacFcGb6MEL7z3XFE8M1cTS7tlU1uHOTjrg37jGv7gG33Nw9
         eULpvhdrouuoIdnLtmQEty6grYkq1KjGVNQ2jNvuEGeGf2LvhY/4aIxw39KNvFOSWQyn
         UZfw==
X-Gm-Message-State: AOAM533Q6KPWjIypLUPv5C2C4FwGguAWli56gTE4LfyQ6R06LeAPkbW5
        uCMm1vroW2yNw0cvBhMbynMNIACsAQuhOw==
X-Google-Smtp-Source: ABdhPJxdkujaXrlCjXWhqZTfutzuO+JMeWMDrxdXVJaUJNjoSFKY+cvm3hqUX1E44XdinkGvphkNLg==
X-Received: by 2002:a17:907:8692:: with SMTP id qa18mr10475788ejc.7.1636643287429;
        Thu, 11 Nov 2021 07:08:07 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id y15sm1869027eda.35.2021.11.11.07.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:08:07 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/4] Refactor the logic for writing trace data in the file
Date:   Thu, 11 Nov 2021 17:08:01 +0200
Message-Id: <20211111150805.86419-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

When a trace buffer data are written in the trace file, the buffer
option in the file metadata is updated with the file offset of the
tracing data. Hide this logic into the trace-cmd library.
Added new APIs:
 tracecmd_add_buffer_info()
 tracecmd_write_buffer_info()
Changed APIs:
 tracecmd_append_buffer_cpu_data()
Removed APIs:
 tracecmd_add_buffer_option()

Refactored the internal logic of tracecmd_write_cpu_data() API to be
suitable for upcoming trace file format changes and data compression.
The size and the offset of the trace data is saved in the file right
after the data is written. The old logic calculates the size and offset
in advance, but when the trace data is compressed it is hard to use
that approach.

This patch-set depends on:
 "trace-cmd fixes and clean-ups" patch set.
 "Refactor APIs for creating output handler" patch set. 

v3 changes:
 - Bug fixes.
 - Rebased on top of the latest master.

v2 changes:
 - Fixed wrong calculations of trace page alignment.

Tzvetomir Stoyanov (VMware) (4):
  trace-cmd library: Add internal database for trace buffers
  trace-cmd: Use the new trace buffers API
  trace-cmd library: Helper logic to update the trace buffer offset
  trace-cmd library: Refactor the logic for writing trace data in the
    file

 .../include/private/trace-cmd-private.h       |  10 +-
 lib/trace-cmd/include/trace-cmd-local.h       |  19 ++
 lib/trace-cmd/trace-output.c                  | 322 ++++++++++++------
 tracecmd/trace-listen.c                       |   2 +-
 tracecmd/trace-record.c                       |  18 +-
 5 files changed, 253 insertions(+), 118 deletions(-)

-- 
2.33.1

