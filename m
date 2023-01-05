Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DF80C4708E
	for <linux-trace-devel@archiver.kernel.org>; Thu,  5 Jan 2023 22:52:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbjAEWwh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 5 Jan 2023 17:52:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236311AbjAEWw1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 5 Jan 2023 17:52:27 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DA6463F40
        for <linux-trace-devel@vger.kernel.org>; Thu,  5 Jan 2023 14:52:25 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id j8-20020a17090a3e0800b00225fdd5007fso2160pjc.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 05 Jan 2023 14:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BFrWsAL7q6HFvMZWS63yQeCx/8JbADMlHmEfLWQrgjs=;
        b=FS6JsM8GQYgM2qjPPSmUoUm+o7g0zHfT58AkhvwbsudezvKUjeSQtaxU8dkwGm3p7B
         a+GDdCIp+542TdGHVSFx2gYN4+4g/soKxfy0v6dQYai9ZVbptOfZSnedZwNDHxznuVaN
         sGlgQpSSGJazoxtNdbera7RnrpTalHuo0Knkj07MZx5Yb1qIOrUMTuI/w3ZQ1XyUGC+5
         yYB0hOy0XOBRsmkU0kmvlU/UCMfJUYDcDh8zbfSW85LoPr8cQlwnv5avaWm7u5KK5/YB
         HuU5lUfPhP81V8daDEpCkGf86QV5ImpzobcCp8Atnq12ElyL47VM8DGNt/wLGa/UDvcK
         +xGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BFrWsAL7q6HFvMZWS63yQeCx/8JbADMlHmEfLWQrgjs=;
        b=0xReVp3gYo1uorePbNkTDt8T+zuWpTnPv/DC6YiKfWMPjxt6ZXSCcmVR9J69/8a4aM
         AzMvWWlKpUKqbxe9orILYUDQoxy7JuEI6c4vGIACQYk04brurW58x/KAQdeC01qZ/yHs
         niMMpdzXWDhxkzB5tidI9HOMJSM6MfRf9GA1yvYad75RoZXQqGFBaDz9hplgjmSwnmc9
         Pt8ob52gi6W6ekrmKzAHA2A/RQYjg/0/MxtB7st2djkzL36RiELUbGATHKecxkLZk/gY
         ycq5Zf6b4VDN64L9fdo5TNDsjmqbDL1Mb+uCE6Dwbjf6JerYKZ+BFuly9umnDwR5QEm4
         WhQQ==
X-Gm-Message-State: AFqh2kq1FfYrNkGyxKHnil3OTwTLZBkLsZfeaEFThW8gR+ewMBiOdtEF
        TvsJXVF0BOehOMbPemrTSlyzoOxbAZA=
X-Google-Smtp-Source: AMrXdXs3P2k3w84HWJPgmGAq55E+IPMNYzk9MA0cTowT52ts4Vue7db0eKC9Ys4KV0N6Peku8FKnTg==
X-Received: by 2002:a17:902:b48e:b0:18b:cea3:645 with SMTP id y14-20020a170902b48e00b0018bcea30645mr13690924plr.0.1672959144617;
        Thu, 05 Jan 2023 14:52:24 -0800 (PST)
Received: from mail.google.com (125-237-24-141-adsl.sparkbb.co.nz. [125.237.24.141])
        by smtp.gmail.com with ESMTPSA id l19-20020a170902f69300b00177efb56475sm26587743plg.85.2023.01.05.14.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 14:52:24 -0800 (PST)
Date:   Fri, 6 Jan 2023 11:52:19 +1300
From:   Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     paulo.miguel.almeida.rodenas@gmail.com
Subject: [PATCH] trace-cmd: document expected behaviour of execvp for record
 command
Message-ID: <Y7dUo6woh9Y31cdl@mail.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

In tracecmd/trace-record.c:<run_cmd>, trace-cmd record -F <executable>
is launched via the libc's execvp() routine.

If you run a command which is meant to be found in one of the entries
of the PATH env var then you should see <n> invocations of the
__x64_sys_execve() syscall where <n> will be equal to the number of
attempts that execvp() routine had done until it could find the
executable.

While the routine works as expected, its behaviour can seem a bit
cryptic for untrained eyes and makes one wonder whether there is
something wrong in any of the parts involved in the tracing operation.
Some time after one digs into trace-cmd's and libc's code base, one
realises that everything is working as expected but documenting it could
save other people's time :-)

Document the expected behaviour ftrace users should see depending on
the way -F <executable> is used.

Signed-off-by: Paulo Miguel Almeida <paulo.miguel.almeida.rodenas@gmail.com>
---
Additional context:

- absolute path example:

	# trace-cmd record -p function_graph \
		-g __x64_sys_execve -O nofuncgraph-irqs \
	        -n __cond_resched --max-graph-depth 1  \
		-F /usr/bin/echo "ftrace" > /dev/null
	
	# trace-cmd report 
	echo-172994 [000] 185539.798539: funcgraph_entry:      ! 803.376 us |  __x64_sys_execve();

- PATH-dependent path example:

	# trace-cmd record -p function_graph \
		-g __x64_sys_execve -O nofuncgraph-irqs \
		-n __cond_resched --max-graph-depth 1  \
		-F echo "ftrace" > /dev/null

	# trace-cmd report
        echo-172656 [002] 185009.671586: funcgraph_entry:      ! 288.732 us |  __x64_sys_execve();
        echo-172656 [002] 185009.671879: funcgraph_entry:      ! 158.337 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672042: funcgraph_entry:      ! 161.843 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672207: funcgraph_entry:      ! 157.656 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672369: funcgraph_entry:      ! 156.343 us |  __x64_sys_execve();
        echo-172656 [002] 185009.672529: funcgraph_entry:      ! 863.629 us |  __x64_sys_execve();

---
 Documentation/trace-cmd/trace-cmd-record.1.txt | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index b709e48..a000cbe 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -113,6 +113,10 @@ OPTIONS
     Using *-F* will let you trace only events that are caused by the given
     command.
 
+    Note: if the specified filename is neither absolute or relative then libc
+    will invoke execve() syscall for every entry in the colon-separated list of
+    directory pathnames specified in the PATH environment variable.
+
 *-P* 'pid'::
      Similar to *-F* but lets you specify a process ID to trace.
 
-- 
2.38.1

