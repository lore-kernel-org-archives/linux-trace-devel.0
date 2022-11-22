Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE29CC4332F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Nov 2022 17:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233845AbiKVRiG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Nov 2022 12:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233923AbiKVRiC (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Nov 2022 12:38:02 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0AAEC74A
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Nov 2022 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669138624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Aj+Hy7/pmo4M08v1ZMJrMPL04jwIP+2wr02vMZIdx8Y=;
        b=YZsFMqpE0vf1LBah2md3JYEI1b6L0ZbwJ750hrDCl3sKnXrYBIpP433N1obFbYjScMsAml
        biNzmj8HIY+KNJh/N+4nJ7lfAc9WGIyZhVNid9wUlH73GXA+17LJaxGkQ51h2DKaUVSbFu
        Jmv84+y3dJTmVHLSPOxOcPNXP3zsD+M=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-227-vtmufoQCPZiW36qoT0oTsg-1; Tue, 22 Nov 2022 12:37:03 -0500
X-MC-Unique: vtmufoQCPZiW36qoT0oTsg-1
Received: by mail-ed1-f70.google.com with SMTP id q13-20020a056402518d00b00462b0599644so9346708edd.20
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Nov 2022 09:37:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aj+Hy7/pmo4M08v1ZMJrMPL04jwIP+2wr02vMZIdx8Y=;
        b=C4PswjCyPNS9lan5gS8KIYKd0U/R0WYlYGgWSrVnR9tiiXA9ovGXgpERvkv8tyhs1y
         I/ToW9BV0VCdm4Jy/UBykDB1bDb6LaSfHHFPHEkKECTMvOsFne5xBc4jdRnBqaunhMSJ
         /uNYRgUrk0fIVr2r8jyQriLDzB11wSPTZconv2pyai8dNO9/nSWFjx33pyZMmFIBUMWN
         WmVTKJWEo0+cr3DZGrpwejhVNDnY6NUn+acK6P93YWxFAKiCgDbKxSIv7tJvr5MsEHd0
         qDnZt+scJJld50DyJzqthCNo15l/MBX86hwEnm5AspZgvCYE7JUzFr3uZW/JxPdHT9oz
         XpkA==
X-Gm-Message-State: ANoB5pkC0LTBj02gyIdNoi6KiLKh4OK2FhnIULkadS2O8x9VzXr1otbW
        d1eSTToljstVcE5HTPuYrM8ZeGQlCdxM2ur/WYpulPKeZxA2y3gGlAB0S6Mv+sMDemxJA+9xJuq
        ddYs2jmrskm3sQgu+lXO6Uax88YZMGlTX6a4+WOlsFydJeDBa869JxpwyxLdMcDHzA9bEbT9Y9y
        vN6dpQHI4=
X-Received: by 2002:a17:906:a40c:b0:7ae:180e:9b53 with SMTP id l12-20020a170906a40c00b007ae180e9b53mr20717464ejz.206.1669138622084;
        Tue, 22 Nov 2022 09:37:02 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5+YDUMQsIqm2ye9t7VXvKKmkQPj+CpN04bUStnpfXPdyYFH/5C9Te+k8AiyJ9cY9q9CDm77Q==
X-Received: by 2002:a17:906:a40c:b0:7ae:180e:9b53 with SMTP id l12-20020a170906a40c00b007ae180e9b53mr20717440ejz.206.1669138621796;
        Tue, 22 Nov 2022 09:37:01 -0800 (PST)
Received: from x1.hqhome163.com ([194.183.10.152])
        by smtp.googlemail.com with ESMTPSA id kw1-20020a170907770100b0078246b1360fsm6290759ejc.131.2022.11.22.09.37.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:37:01 -0800 (PST)
From:   Alessandro Carminati <acarmina@redhat.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     alessandro.carminati@gmail.com, acarmina@redhat.com,
        bristot@kernel.org, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] rv/monitors: Move monitor structure in rodata
Date:   Tue, 22 Nov 2022 18:36:48 +0100
Message-Id: <20221122173648.4732-1-acarmina@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <7febf4f5-88d9-7902-e231-af2b6d0d6df0@kernel.org>
References: <7febf4f5-88d9-7902-e231-af2b6d0d6df0@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

It makes sense to move the important monitor structure into rodata to
prevent accidental structure modification.

Signed-off-by: Alessandro Carminati <acarmina@redhat.com>
---
 kernel/trace/rv/monitors/wip/wip.h   | 2 +-
 kernel/trace/rv/monitors/wwnr/wwnr.h | 2 +-
 tools/verification/dot2/dot2c.py     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/rv/monitors/wip/wip.h b/kernel/trace/rv/monitors/wip/wip.h
index dacc37b62a2c..2e373f2c65ed 100644
--- a/kernel/trace/rv/monitors/wip/wip.h
+++ b/kernel/trace/rv/monitors/wip/wip.h
@@ -27,7 +27,7 @@ struct automaton_wip {
 	bool final_states[state_max_wip];
 };
 
-static struct automaton_wip automaton_wip = {
+static const struct automaton_wip automaton_wip = {
 	.state_names = {
 		"preemptive",
 		"non_preemptive"
diff --git a/kernel/trace/rv/monitors/wwnr/wwnr.h b/kernel/trace/rv/monitors/wwnr/wwnr.h
index 118e576b91b4..d0d9c4b8121b 100644
--- a/kernel/trace/rv/monitors/wwnr/wwnr.h
+++ b/kernel/trace/rv/monitors/wwnr/wwnr.h
@@ -27,7 +27,7 @@ struct automaton_wwnr {
 	bool final_states[state_max_wwnr];
 };
 
-static struct automaton_wwnr automaton_wwnr = {
+static const struct automaton_wwnr automaton_wwnr = {
 	.state_names = {
 		"not_running",
 		"running"
diff --git a/tools/verification/dot2/dot2c.py b/tools/verification/dot2/dot2c.py
index be8a364a469b..87d8a1e1470c 100644
--- a/tools/verification/dot2/dot2c.py
+++ b/tools/verification/dot2/dot2c.py
@@ -111,7 +111,7 @@ class Dot2c(Automata):
 
     def format_aut_init_header(self):
         buff = []
-        buff.append("static struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
+        buff.append("static const struct %s %s = {" % (self.struct_automaton_def, self.var_automaton_def))
         return buff
 
     def __get_string_vector_per_line_content(self, buff):
-- 
2.31.1

