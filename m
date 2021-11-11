Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 707CFC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5923561252
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Nov 2021 15:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234038AbhKKPQI (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Nov 2021 10:16:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbhKKPQI (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Nov 2021 10:16:08 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB880C061766
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c8so25086606ede.13
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Nov 2021 07:13:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=Vy8Bm4iMbv5xjHwdGA/C+NqdfDjKLRvsldXoFSS6qUfVyqrh8oK7/rG3bgrq5T8MdL
         aQ8uPXcyiF25uMLM4RaOY52MXnzSFnMWElt9587nlwYRxy5ZWAxYfEye3KdJ8Q11Fjnn
         u88riG4raUMT7V+gUbCUBz38pRs89yoJi7G91SkC5Jx937ZJPbZlQ1eIo0+/8pUl+nDb
         HKhShk0jMLNncSCbt0CDLE/j7jjsYVtKccPEO9SvCcFuK351MYJ3NyeBe5AqhdKe5FVn
         TenXvzE9PruTfnVlxZza3HaW0f85/4zQ9erp2dvcgnQ9lR+SQH2dzZHtFcqdSxRau9EJ
         871A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VbZnL0lpdI+vGNQrRjSgtZTvcxT/t2MeibgH9TMT8kA=;
        b=qqofzeHoa+cnXFMAuZIBMA0BzeBMVMHYF8+ZNpMHct/YH99w6NjPShbyHqdErVlN2y
         zsCCdJKw5vSKeQKjydormeFy9DC9EqkeZjkLV/U6lxisUZPJlYdriEs7I0t+mneGq0zq
         Sa7qK2xJx8OIfvJpo6hH6zocikrFbVi72byDPk8ijMV2NKflx+H/hfTaWdf6wMo4tBIZ
         OtOZY8j975Q6yoJq869YY6tnm+TGiIrnsAe0LDf239RPBfaG21A2HVaTrb/Ei/rHo2GH
         pdFu25Bwh7UlUrLf0+4P+qbiQqfP00jOG10l2jREaG4NL1/Tl+qsZ0Bs3RbFDDUQcNMi
         BxxA==
X-Gm-Message-State: AOAM5322dTjUjriCZLhXPnQzRN3jL3WqzeWgvP6Xe0H5d7bDKCkcRG0m
        iV/yNGw9CKWLsz9+pu9JuvSfO6pYm9jbTQ==
X-Google-Smtp-Source: ABdhPJxL0a/FPzHr+alEcGQo5zBfv+KU0Ax8TaqFv9S7NArqT5NSB2h0Lv1xwbCz6N76ZdbYe9pMeQ==
X-Received: by 2002:a50:d78c:: with SMTP id w12mr10709099edi.147.1636643597439;
        Thu, 11 Nov 2021 07:13:17 -0800 (PST)
Received: from oberon.zico.biz.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id gb3sm1545093ejc.81.2021.11.11.07.13.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Nov 2021 07:13:17 -0800 (PST)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v4 1/4] trace-cmd: Update bash completion
Date:   Thu, 11 Nov 2021 17:13:11 +0200
Message-Id: <20211111151314.87148-2-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211111151314.87148-1-tz.stoyanov@gmail.com>
References: <20211111151314.87148-1-tz.stoyanov@gmail.com>
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
2.33.1

