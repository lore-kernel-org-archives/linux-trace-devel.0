Return-Path: <SRS0=YrCp=AD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09B9EC433E0
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:37:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9FB120738
	for <linux-trace-devel@archiver.kernel.org>; Mon, 22 Jun 2020 14:37:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XazdNAzQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729376AbgFVOhA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 22 Jun 2020 10:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgFVOg7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 22 Jun 2020 10:36:59 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701C6C061573
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:59 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n24so18281206ejd.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 22 Jun 2020 07:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qBOjP8ipEmc/TrWTrsO+XeN1pI727V8e9caJnqdouHk=;
        b=XazdNAzQJXvOFNHLPYE3MAyM67oUCiuqwKMI0fcAHDPPQcQs6JhgEVvV597C3PNyKF
         wtCu5fk13TlFV1sQ582fFny6Ep1k9Q8XKMJkyOTki+np+JCwNJuoptn+A8gMyjm5cMJq
         fp+8mV9SBBClfYyYbEeB8QOfzKE5h5FPohQyqKSFtcd80gRtaWJvoxdL4qUa9Nrjy7lb
         IwObkmlDUcqC2jGJx57qcBTuB7x2OEJ7tGP0xRBjnOfauL36fGnLV1HwtZvLoLAP13e6
         s+UyyB1U+63nVeAtloUgMp193grtymZ4/+/1gZRqiIHTG87F+N6c4ROsb8BspnVPTxAH
         WwtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qBOjP8ipEmc/TrWTrsO+XeN1pI727V8e9caJnqdouHk=;
        b=pfVWpUVm0veSlEzeZIB+42Im9HdC/8/p5qS/cNzCUzfQRcAi+vvnXFboMlRvceUnK7
         ZwiSYV1PmvMLlqwsEjFfm2FSQva2bXdZMm8LftQzKh0ewijDIHK2sEKnCYa/yD/rNSEF
         BOToMg1EIIDBk1JhuNESkz5XmTF2wgvtvoZAjPMnuRhFu7rkC5dasQNbXISv72S6WETj
         amNSGx8CllYAC/nIDQ2iJecD1pamTpygBEFXoyeyvljQIMX6WlA5wQzakn1SA/nI6VHr
         rOr/ucSs0V3XSBWMLAgDysOgw8GKcgixWNuQKJglR9R3DcMGIxByKR6MK/8FOQiI2g44
         NUeA==
X-Gm-Message-State: AOAM530wtuNLdcdsIKZ/ncNqWSKFHeBzaHxEv+ip0bI8AIhtR0I1dGP9
        f6FPOfdiUaN3Ld9l2d42CDaF4GRRZHY=
X-Google-Smtp-Source: ABdhPJzDlw4tMgMXXNf4L5Bz44SDUrzkWsPDOGLSyN8qxVWW10dRdloqw/Si5X2CMbifHm7+IS+3FA==
X-Received: by 2002:a17:906:d791:: with SMTP id pj17mr15907121ejb.352.1592836618214;
        Mon, 22 Jun 2020 07:36:58 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id z1sm11810259eji.92.2020.06.22.07.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 07:36:57 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH v2 4/4] trace-cmd traceevent: update KVM plugin
Date:   Mon, 22 Jun 2020 17:36:51 +0300
Message-Id: <20200622143651.179674-5-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200622143651.179674-1-tz.stoyanov@gmail.com>
References: <20200622143651.179674-1-tz.stoyanov@gmail.com>
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
Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>
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

