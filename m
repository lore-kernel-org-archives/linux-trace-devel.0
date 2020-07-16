Return-Path: <SRS0=576e=A3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397C8C433E5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11EF920656
	for <linux-trace-devel@archiver.kernel.org>; Thu, 16 Jul 2020 09:19:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rrTwg3L3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgGPJT2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 16 Jul 2020 05:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgGPJT2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 16 Jul 2020 05:19:28 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DE6C061755
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:28 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id p20so5773571ejd.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 16 Jul 2020 02:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYocCSj+R8sDwKW/AA6NnTZvmkXRLf5UHEPEAgASkd0=;
        b=rrTwg3L3/pVSHSEHimzdN0lKyf+f2a2AzA0PAxIHyXcXDXCgpzmbNxc09rPVhUtx+7
         feTygaoTObPx5SNRKjhiZ5uZhpjNBlMcIW/4WcDG1BEbFwEauUEQxjzKTTIu4qfc/D/u
         GpEPb+NNZOLZ2M4e0KRCBgRn8hXNo3FZzpc2ZzYXtTuHrFGUZ9JqBAezLWws6unM7I5K
         zpyRUTsmxWMB+52rbsEe5I/7s0jvNUU+N60uR/HYO/qQcE21izgmwLMMrjlHQLCBjDfD
         zTLgdpdI3+ndrXm5v/1Yhhe6CfPyCfV0AoRRd5Piz1d7fPg5QfVz8ggpeTazTD6wZRKK
         8l+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hYocCSj+R8sDwKW/AA6NnTZvmkXRLf5UHEPEAgASkd0=;
        b=Mc31w+qtxNQO26W1c18s25vocp7I5aSJz2zrR9lXBefWsbqIa3c0MuQvCUk/zFGSQI
         S7TpMcjUPcx19Duk5n1bYWE+YN4gBzqzeNJHtqsIx7EvK7Gs0BBeBxG1Dd6H8152a34c
         9THqmGFfkIddjpjPwwa+oW9X7YNS8BORel0x+r9uh5nqsX32CTXTE61/0kgrqdSs9+7i
         0KjFxmzSqpMJXxBKcfEoqVhGLygdnuz+le+5VUJDm4zpyvhlximk0bL7pdVn2RCDgqhd
         e4u+/2RPBdoXAx4I/2SyeXwXwXOaaDFgtYUxF5huJ+y69nSVkBn5Rd6kLeNyze6Y7imX
         zSKQ==
X-Gm-Message-State: AOAM531VnYrwZt9QNiojEUC2mbVrQsu5vj3S46990dfIqYlohgh9rNMC
        9QZ5QEAZuhter00yovOCdVrRyYBYByo=
X-Google-Smtp-Source: ABdhPJyfRORLrN3piC3deGddUeb822hXZPqfRpjuIztc1TCfFW7xaDobhG90i97wxZSERADqk0aIXA==
X-Received: by 2002:a17:906:7709:: with SMTP id q9mr2770730ejm.123.1594891166652;
        Thu, 16 Jul 2020 02:19:26 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id x9sm4431534ejw.28.2020.07.16.02.19.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:19:25 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/8] Backported libtraceevent fixes, suggested by Namhyung Kim
Date:   Thu, 16 Jul 2020 12:19:15 +0300
Message-Id: <20200716091923.2613228-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

libtraceevent fixes, backported from trace-cmd repository,
suggested by Namhyung Kim <namhyung@kernel.org>.
There is one additional enhancement over the original patch set:
a man page, describing tep_load_plugins_hook() API is added in
"tools lib traceevent: Document tep_load_plugins_hook()"

Tzvetomir Stoyanov (VMware) (8):
  tools lib traceevent: Document tep_load_plugins_hook()
  tools lib traceevent: Handle strdup() error in parse_option_name()
  tools lib traceevent: Fix typo in tep_plugin_add_option() description
  tools lib traceevent: Improve error handling of
    tep_plugin_add_option() API
  tools lib traceevent: Fixed broken indentation in
    parse_ip4_print_args()
  tools lib traceevent: Fixed type in PRINT_FMT_STING
  tools lib traceevent: Fixed description of tep_add_plugin_path() API
  tools lib traceevent: Handle possible strdup() error in
    tep_add_plugin_path() API

 .../Documentation/libtraceevent-plugins.txt   | 25 +++++++++-
 tools/lib/traceevent/event-parse-local.h      |  2 +-
 tools/lib/traceevent/event-parse.c            | 10 ++--
 tools/lib/traceevent/event-plugin.c           | 50 ++++++++++++++-----
 4 files changed, 67 insertions(+), 20 deletions(-)

-- 
2.26.2

