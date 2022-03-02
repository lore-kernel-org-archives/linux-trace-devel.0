Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38DCC433F5
	for <linux-trace-devel@archiver.kernel.org>; Wed,  2 Mar 2022 04:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233178AbiCBEwS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 1 Mar 2022 23:52:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiCBEwS (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 1 Mar 2022 23:52:18 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AE6B0EA1
        for <linux-trace-devel@vger.kernel.org>; Tue,  1 Mar 2022 20:51:35 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qx21so1146301ejb.13
        for <linux-trace-devel@vger.kernel.org>; Tue, 01 Mar 2022 20:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3JQfJEC63S/C5X9sQnx9qkfeTcwK5Yh8a+dT3XLaLyc=;
        b=D5NW9lUpGYCJCq9qqbavMGYg+SFsPnS6er4Np/fk9TOOrd2Tls5zlx8+sDRmbp8i79
         RbQBPEQqbw2hz08g/i7JDG3OogE4YcKHrXEuBXf4dRmPbHJtU9KyDzXJBRCFQS1z7+5c
         Fi7FxiQosW9QD9JB5YY05kid44C95WuS23x1Hcjntwbn7KG7wmn8FI1Z35EeUgQrfAlN
         voWlpGxGt/4m0nu4zy24h3QHUPLVZEWehzGPwQ4Db7UYzFG2qYc9TIFoOBlrtMefFjSy
         5w62bVMddyBaJYYtFQp9NMF5uH9PuXXPdIYE9a5St66Bz4AZBjDtZtdZvFl0jN56neQH
         2QwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3JQfJEC63S/C5X9sQnx9qkfeTcwK5Yh8a+dT3XLaLyc=;
        b=avSEWpt6T4ufEzn4BE+tZqsZHcyA2d7qRNuZpy1PLchP0bvc1SBRJAIGZCQwip/7IT
         J/21OTj6jFSJ88sbPsSHEObUC+i/zBgKYL57w6zQbtjfTycnWynuBPsH4lgnPUR+hHV9
         iFWnYGa3aWcMlynvaIueI3c743QoUWhCKbHiEpYL04Fttj1DqHEtlU4etgAMxBD7ehwZ
         aWZ5CA3+0dz1IIUgmDXURLLU06L8yNDLJMHwlM+eDuNWKZngFlgK+nT6nBNA8etrEflh
         ivmvzO6yb+ZleALM76FT88TvAdgffLpHjs1MdyfYJufuJGlNVURZwgJ3z3JL+a6XoNRV
         5Q4A==
X-Gm-Message-State: AOAM531QN3CECFQyWTul+pvPNGM6k5WouWfEyODcDry3JeLENEof8qsx
        I/ABC01Xyj0RRIo8NFB2Gz05EAn34QY=
X-Google-Smtp-Source: ABdhPJxce6V4rYxJTu68x8kW9t/LY3/8DlA6AHAVgo3FqiycPHiKEoNC81l/H9ZvXIgEl5eXcax1CA==
X-Received: by 2002:a17:906:7246:b0:6d6:e43a:e487 with SMTP id n6-20020a170906724600b006d6e43ae487mr5573212ejk.455.1646196694102;
        Tue, 01 Mar 2022 20:51:34 -0800 (PST)
Received: from oberon.com ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id ce7-20020a170906b24700b006cf095c2f5bsm5941036ejb.83.2022.03.01.20.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 20:51:33 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     sebastian@breakpoint.cc, linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/5] trace-cmd: Improvements in compression logic
Date:   Wed,  2 Mar 2022 06:51:26 +0200
Message-Id: <20220302045131.387658-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Improvements in internal comperssion APIs, suggested by
Sebastian Andrzej Siewior.

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Use a structure to describe a compression protocol
  trace-cmd: Make internal compression hooks more generic
  trace-cmd: Use errno from zlib, if available
  trace-cmd: Add context to compression hooks
  trace-cmd: Use context hooks in zstd

 .../include/private/trace-cmd-private.h       |  20 ++--
 lib/trace-cmd/trace-compress-zlib.c           |  41 ++++---
 lib/trace-cmd/trace-compress-zstd.c           | 100 ++++++++++++------
 lib/trace-cmd/trace-compress.c                |  80 +++++++-------
 4 files changed, 144 insertions(+), 97 deletions(-)

-- 
2.34.1

