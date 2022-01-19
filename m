Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382FAC4332F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 19 Jan 2022 08:32:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234262AbiASIcY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 03:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351302AbiASIcY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 03:32:24 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02492C061574
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:24 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id p12so7579778edq.9
        for <linux-trace-devel@vger.kernel.org>; Wed, 19 Jan 2022 00:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MGXHuQX5vwaqYPPtMcMPtJdnP+a4bN96V7nhqFeCZ9w=;
        b=XZR9ucohhWJoZiaithUPDpJdpupjlDWKeHpub8TAHek4Zab6ioIiiGo0u1dhcezRg1
         81FAzR2w92+2CHLKSZV8y2bOWWSi0tzfvxzrxbJ8ZRybgnd+I23nvRTfyCjQfs4+cZbP
         7dIG5V2fDhuYuOwYW6UfcgrrsSgAdqgI5nF0sUByx9I3QmQ/cWjoqWtkO3WDPSuL6eOa
         UsSq7S8FcgJKbCwurY+do4UTBmHJE9ivk8MRWIYPzZeX2QAfcYgu0k05BttfMBwigFgP
         dg5Xzu3ideyjcBr05WsryrFc02cyb8NXsImpI9WUSvaZNLGpEFNr9UXtuSK337GZZlJb
         0r4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MGXHuQX5vwaqYPPtMcMPtJdnP+a4bN96V7nhqFeCZ9w=;
        b=Uk8uBCyS8EfCRXjAeMGVZ6UQCC5kMl2JUANozg0406NjvRNbT8bqlYVWXK64zfUye8
         9Wjr2ZUxmACB/q3zQuxaSBjRUfj5aFBsz9Bd0c9jSycYBWG9xKOonIEvy5aJ5VlfZEdf
         qyNHaCOqgIwfz1RGwfAJ3uJU3/A6zQ4JNr4Zs3t7R0JpCj8JV3jkgi9zB60txNsRjEVm
         ZxQHT3h3zDjPlzcwIwIBjCAnAUZ4o+3mcvPjYOLpEoOOX1C+Hh2WoRpJ0WNQC/n6nF4S
         kT2Il25nHt0vLEzZqYjv8yoVXaPkEglfpzk1AsqzfIpuhD8Fm4pns+3xeBe/bnC2A9Ri
         PCdw==
X-Gm-Message-State: AOAM5309f9HYYVf1bhNHT73uzjOYoxILNq9HvP3C/FAkcjsYBInYmZw8
        cBHObp3s1+zEilO2JoE/YDA=
X-Google-Smtp-Source: ABdhPJyuirMk8feBEA9lojM0n8TOJATGJdCxnEbx7sgTgfX0rRsvqhtc1CGblnYvJe7Nzy+ctdz9OA==
X-Received: by 2002:a17:907:869e:: with SMTP id qa30mr23502410ejc.137.1642581142518;
        Wed, 19 Jan 2022 00:32:22 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z6sm875969edb.58.2022.01.19.00.32.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Jan 2022 00:32:22 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v7 1/4] trace-cmd: Update bash completion
Date:   Wed, 19 Jan 2022 10:32:16 +0200
Message-Id: <20220119083219.246347-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220119083219.246347-1-tz.stoyanov@gmail.com>
References: <20220119083219.246347-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Added convert subcommand and its arguments to bash completion logic.

Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
---
 tracecmd/trace-cmd.bash | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tracecmd/trace-cmd.bash b/tracecmd/trace-cmd.bash
index b01c7a07..6639c143 100644
--- a/tracecmd/trace-cmd.bash
+++ b/tracecmd/trace-cmd.bash
@@ -64,6 +64,13 @@ plugin_options()
     COMPREPLY=( $(compgen -W "${opts}" -- "${cur}") )
 }
 
+compression_param()
+{
+    local opts=$(trace-cmd list -c | grep -v 'Supported' | cut -d "," -f1)
+    opts+=" any none "
+    COMPREPLY=( $(compgen -W "${opts}") )
+}
+
 __trace_cmd_list_complete()
 {
     local prev=$1
@@ -181,6 +188,9 @@ __trace_cmd_record_complete()
 		cmd_options record "$cur"
 	    fi
 	    ;;
+	--compression)
+	    compression_param
+	    ;;
         *)
 	    # stream start and profile do not show all options
 	    cmd_options record "$cur"
@@ -222,6 +232,29 @@ __trace_cmd_dump_complete()
     esac
 }
 
+__trace_cmd_convert_complete()
+{
+    local prev=$1
+    local cur=$2
+    shift 2
+    local words=("$@")
+
+    case "$prev" in
+	-i)
+	    __show_files
+	    ;;
+	-o)
+	    __show_files
+	    ;;
+	--compression)
+	    compression_param
+	    ;;
+	*)
+	    cmd_options convert "$cur"
+	    ;;
+    esac
+}
+
 __show_command_options()
 {
     local command="$1"
@@ -298,6 +331,10 @@ _trace_cmd_complete()
 	    __trace_cmd_dump_complete "${prev}" "${cur}" ${words[@]}
 	    return 0
 	    ;;
+	convert)
+	    __trace_cmd_convert_complete "${prev}" "${cur}" ${words[@]}
+	    return 0
+	    ;;
         *)
 	    __show_command_options "$w" "${prev}" "${cur}"
             ;;
-- 
2.34.1

