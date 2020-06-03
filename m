Return-Path: <SRS0=eJz3=7Q=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 712CEC433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51DEF206A2
	for <linux-trace-devel@archiver.kernel.org>; Wed,  3 Jun 2020 12:15:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4W077pg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgFCMPP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 08:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgFCMPL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 08:15:11 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEC7C08C5C0
        for <linux-trace-devel@vger.kernel.org>; Wed,  3 Jun 2020 05:15:10 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id q25so1812764wmj.0
        for <linux-trace-devel@vger.kernel.org>; Wed, 03 Jun 2020 05:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhDWCExksgcRUyerjmdhBUtM0sNJiqdMCgw0Actq+mQ=;
        b=D4W077pgkzkawE6BD6DeKzKrXrxeA5zxwDP4HJ8QmbbGXkQFjsZDQJDFGboJRZkw07
         Ee57ejnZ63Za9s782QtuYVPaGctp5ig8UA7bXW/g+UvAabhfkXEJ4aXVPLjk4YG/TFAD
         AXflImOrRV1WIsHu21aXcnWau+6n4KZFXlis8HJCZf2eeCS49hb4r8QTcZrlfhFRNFjY
         /0fQs8J7wN8ljn9FctLG79MB6nwmJ389dhmhyUz7vYgloo/nz8sayqilNpmzOGOvtxaI
         qOGmYmBIVf8S+6Um+wuRGg7lKJS8+vrk6YAtDQSuxQyhyimmnLOaCJaKol3IMebqgqX2
         Yy7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=yhDWCExksgcRUyerjmdhBUtM0sNJiqdMCgw0Actq+mQ=;
        b=D06Gvz5B7a79jw9+m0y1xVZYsR2KkTx4NMhkr2XfhDWvb2Q+FXGt/dS2nsgeW782jx
         H4iryzlW3VD1UDh73LgOaMguSfNaHjaUKpc8ORRP6u5W3edHBUcmQ/fkzAlXvpYaxAz8
         Fu49w+xTzqi6jIm2kzELrLLQbwz4LEdasRT7RojUrvKrIsLCVpRWoUZRq+7BSpnxyn37
         rs3xwtWGrFTKshfTDF6cB+piN+H6sPl70BjvYhT1gHsHlpFTcLD9k4/ySt34YSlU8P/f
         ElitDLczKiJr6VMEXtcdYe8E2IKgWqyN2N++bzROJSgCTIEIG6qAP0CnFrYkRNG75uOn
         +rDA==
X-Gm-Message-State: AOAM531Ul2h5c5rsmC2djt6J/X9ujZ0aJwNFYquvMIK5V/Cm1rfMFoNk
        QMpdOi/tOmd/6vyfDbXfQEeVEispyWI=
X-Google-Smtp-Source: ABdhPJxSforOunDAqkYwmtV+7S9qk7fqR27X0mnFVvBGRl7JmFGWy1NbL4PM4Fs/dDwNBWiRhGXrbg==
X-Received: by 2002:a05:600c:c3:: with SMTP id u3mr8041578wmm.108.1591186508625;
        Wed, 03 Jun 2020 05:15:08 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id u3sm2657042wmg.38.2020.06.03.05.15.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 05:15:07 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v3 0/5] New trace-cmd "set" command and changes in "start"
Date:   Wed,  3 Jun 2020 15:15:01 +0300
Message-Id: <20200603121506.49992-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

"trace-cmd start": Enable to run and filter a command.
"trace-cmd set": Introduce a new sub command. It works the same way as
"start", except it does not clear the ftrace state.

v3 changes:
  - Added new path in the set:
   "trace-cmd: Extend option "-v" to delete an ftrace instance" 

Tzvetomir Stoyanov (VMware) (5):
  trace-cmd: Enable "trace-cmd start" to run a command
  trace-cmd: Add new subcommand "set"
  trace-cmd: Man page for "set" subcommand
  trace-cmd: Extend option "-v" to delete an ftrace instance
  trace-cmd: Add description of "-G" option

 Documentation/trace-cmd-record.1.txt |   4 +
 Documentation/trace-cmd-set.1.txt    | 259 +++++++++++++++++++++++++++
 Documentation/trace-cmd-start.1.txt  |   2 +-
 tracecmd/include/trace-local.h       |   3 +
 tracecmd/trace-cmd.c                 |   1 +
 tracecmd/trace-record.c              | 134 ++++++++++++--
 tracecmd/trace-usage.c               |  40 ++++-
 7 files changed, 422 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/trace-cmd-set.1.txt

-- 
2.26.2

