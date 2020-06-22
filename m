Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF8BBC433E1
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FC3C2075A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 07:46:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="otZiKkTA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbgFVHqE (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 03:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbgFVHqE (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 03:46:04 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD0E8C061794
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:03 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id k11so16988013ejr.9
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 00:46:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xdjLoejvAAmPGv4uiWBktbKkqkKqoofj/TqT9jvv+9Y=;
        b=otZiKkTAi2xpDtq1U/axRNbJx2eQ3eUD1gE3eS71uajeYQySkoBFM8/3l6wubOAgNL
         p8rT9OgblFMgW0WyACr6cjo3elqMQhPgBQePBsOXVXKLOqmPGJVY1zWlx0oJTqHlh6bo
         US/Rb33CvoM3rwbu1KazANpMmehI0oQmMuoWqcTooshTRXghEWMTS6tdRzhu/OIOLTq4
         alFyCAOLiBsJBczVQG+aHNPQusOXyl1SiN2oVaHf4vd1z/m5T0S7Eo+V2g9ReEBP2caK
         T9s6cJU/5oSlZ/JRhIy6Rjpe+CwM/AGI32QKANOeuVc/aZ0NfKBwix7sXoPuBvMRHosX
         G96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xdjLoejvAAmPGv4uiWBktbKkqkKqoofj/TqT9jvv+9Y=;
        b=eKRbIXhDKkI9T429AGmMyg5VvLUa6eakyUTH+/svPEODUddUTpklDcKdAzMW0SyW6W
         BvEtHzaU8i8i+Vy7ics9Hx6vHQOK8Gqzs8juBZFWQpsQMMSk8GOTlQx5e2x2L9gZiqnE
         Bxzy6eg4U+U/qXv5h1+BFv/R3bx0i7+cidF6hIZg9Nszy5ficyP/Yp8FOMycVu60i6RT
         Ao6hVY54QAtX3FbWkM06jqN0NghwgoniUKDpSfieUI7WGDPRNjkz4PH3Cl6tzqZuyAe7
         og1C2zXizryzlxHTx6tAag9zS8HFPKpTYUn/xbcRcRGA+0rJ80EDqlEGvwYdpIYNqjud
         LCOw==
X-Gm-Message-State: AOAM532xnHdg1tryPg7Bx55x6gHinmwOxJMz10birgzA/3bbszDdc4KH
        sK0LeGXsSciV9dUI1Oj2MxxX7hqG
X-Google-Smtp-Source: ABdhPJzv9dTlLZjHWogTIpx+IpxkREsabkmGMfy7zYGFzpmlk+jNU2sYjCiNRcjdTHvv7aHLecQeVg==
X-Received: by 2002:a17:906:cd2:: with SMTP id l18mr3034137ejh.18.1592811962534;
        Mon, 22 Jun 2020 00:46:02 -0700 (PDT)
Received: from localhost.localdomain ([151.251.241.148])
        by smtp.gmail.com with ESMTPSA id k23sm11094048ejo.120.2020.06.22.00.46.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 00:46:02 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 4/4] trace-cmd traceevent: update KVM plugin
Date:   Mon, 22 Jun 2020 10:45:54 +0300
Message-Id: <20200622074554.151747-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622074554.151747-1-tz.stoyanov@gmail.com>
References: <20200622074554.151747-1-tz.stoyanov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

The format of the role word has changed through the years and the plugin
was never updated; some VMX exit reasons were missing too.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: kvm@vger.kernel.org
Link: http://lkml.kernel.org/r/1443695293-31127-1-git-send-email-pbonzini@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 lib/traceevent/plugins/plugin_kvm.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/lib/traceevent/plugins/plugin_kvm.c b/lib/traceevent/plugins/plugin_kvm.c
index 6c744328..f9f12e57 100644
--- a/lib/traceevent/plugins/plugin_kvm.c
+++ b/lib/traceevent/plugins/plugin_kvm.c
@@ -110,7 +110,10 @@ static const char *disassemble(unsigned char *insn, int len, uint64_t rip,
 	_ER(WBINVD,		54)		\
 	_ER(XSETBV,		55)		\
 	_ER(APIC_WRITE,		56)		\
-	_ER(INVPCID,		58)
+	_ER(INVPCID,		58)		\
+	_ER(PML_FULL,		62)		\
+	_ER(XSAVES,		63)		\
+	_ER(XRSTORS,		64)
 
 #define SVM_EXIT_REASONS \
 	_ER(EXIT_READ_CR0,	0x000)		\
@@ -357,15 +360,18 @@ static int kvm_nested_vmexit_handler(struct trace_seq *s, struct tep_record *rec
 union kvm_mmu_page_role {
 	unsigned word;
 	struct {
-		unsigned glevels:4;
 		unsigned level:4;
+		unsigned cr4_pae:1;
 		unsigned quadrant:2;
-		unsigned pad_for_nice_hex_output:6;
 		unsigned direct:1;
 		unsigned access:3;
 		unsigned invalid:1;
-		unsigned cr4_pge:1;
 		unsigned nxe:1;
+		unsigned cr0_wp:1;
+		unsigned smep_and_not_wp:1;
+		unsigned smap_and_not_wp:1;
+		unsigned pad_for_nice_hex_output:8;
+		unsigned smm:8;
 	};
 };
 
@@ -389,15 +395,18 @@ static int kvm_mmu_print_role(struct trace_seq *s, struct tep_record *record,
 	if (tep_is_file_bigendian(event->tep) ==
 	    tep_is_local_bigendian(event->tep)) {
 
-		trace_seq_printf(s, "%u/%u q%u%s %s%s %spge %snxe",
+		trace_seq_printf(s, "%u q%u%s %s%s %spae %snxe %swp%s%s%s",
 				 role.level,
-				 role.glevels,
 				 role.quadrant,
 				 role.direct ? " direct" : "",
 				 access_str[role.access],
 				 role.invalid ? " invalid" : "",
-				 role.cr4_pge ? "" : "!",
-				 role.nxe ? "" : "!");
+				 role.cr4_pae ? "" : "!",
+				 role.nxe ? "" : "!",
+				 role.cr0_wp ? "" : "!",
+				 role.smep_and_not_wp ? " smep" : "",
+				 role.smap_and_not_wp ? " smap" : "",
+				 role.smm ? " smm" : "");
 	} else
 		trace_seq_printf(s, "WORD: %08x", role.word);
 
-- 
2.26.2

