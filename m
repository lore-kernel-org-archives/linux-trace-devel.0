Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4818EC56202
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 16:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3705221F7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Nov 2020 16:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cogeco.ca header.i=@cogeco.ca header.b="fuw/wbRx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387424AbgKWQWT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Nov 2020 11:22:19 -0500
Received: from mail8137c14.megamailservers.com ([66.226.81.37]:39304 "EHLO
        mail8137c14.megamailservers.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729881AbgKWQWT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Nov 2020 11:22:19 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2020 11:22:17 EST
Received: from laptop-stagiaire.cogeco.local (205-237-37-161.resi.cgocable.ca [205.237.37.161])
        by mail8137c14.megamailservers.com (mail8137c14) with ESMTP id B95C692795E68;
        Mon, 23 Nov 2020 11:15:22 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cogeco.ca; s=email;
        t=1606148136; bh=XZBqXDB7ZACo0zVFLhA0yiDucfEDKb3H8T5PvY4U3CU=;
        h=From:To:Cc:Subject:Date:From;
        b=fuw/wbRxakiOJNSu+kWotWAZOa4qjguqyf48W75Gjnk+dOr0/sBdH3L/Eqz5hfA8Z
         j3VzNnVmucCBq8+seawDdRwAJUKqnUdQe7fBQ4X9BDraffqyijjEPbjQxUyKdOE8cz
         oFXfonUTyJlLuUDszWmnlr6cCSRKj8cMZKyeSnoE=
Feedback-ID: pduplessis@effi
From:   Philippe Duplessis-Guindon <pduplessis@efficios.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        mathieu.desnoyers@efficios.com, linux-kernel@vger.kernel.org,
        broonie@kernel.org,
        Philippe Duplessis-Guindon <pduplessis@efficios.com>
Subject: [RFC PATCH] regmap: remove duplicate `type` field from `regcache_sync` trace event
Date:   Mon, 23 Nov 2020 11:15:19 -0500
Message-Id: <20201123161519.4643-1-pduplessis@efficios.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CSC:  0
X-CHA:  v=2.3 cv=ReTu9Glv c=1 sm=1 tr=0 a=f1nIe4+vFTFun24hu6c7KQ==:117
        a=f1nIe4+vFTFun24hu6c7KQ==:17 a=10vEtgdfLSAA:10 a=7d_E57ReAAAA:8
        a=c_TX95iFyzCk0oM6FUkA:9 a=jhqOcbufqs7Y1TYCrUUU:22
X-CTCH-RefID: str=0001.0A742F24.5FBBE027.007E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-VOD: Unknown
X-CTCH-Spam: Unknown
X-CTCH-Score: 0.000
X-CTCH-Rules: 
X-CTCH-Flags: 0
X-CTCH-ScoreCust: 0.000
X-VADE-SPAMSTATE: clean
X-VADE-SPAMSCORE: -100
X-VADE-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedujedrudegiedgkeejucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecujffquffvqffrkfetpdfqfgfvnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheprfhhihhlihhpphgvucffuhhplhgvshhsihhsqdfiuhhinhguohhnuceophguuhhplhgvshhsihhssegvfhhfihgtihhoshdrtghomheqnecuggftrfgrthhtvghrnhepleeugfehfeekieekfeetgfehgefhudevhedtveegkedthefgieeggeeiieekhefhnecukfhppedvtdehrddvfeejrdefjedrudeiudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepihhnvghtpedvtdehrddvfeejrdefjedrudeiuddphhgvlhhopehlrghpthhophdqshhtrghgihgrihhrvgdrtghoghgvtghordhlohgtrghlpdhmrghilhhfrhhomheprfhhihhlihhpphgvucffuhhplhgvshhsihhsqdfiuhhinhguohhnuceophguuhhplhgvshhsihhssegvfhhfihgtihhoshdrtghomheqpdhrtghpthhtoheplhhinhhugidqthhrrggtvgdquggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehrohhsthgvughtsehgohhoughmihhsrdhorhhgpdhrtghpthhtohepmhgrthhhihgvuhdruggvshhnohihvghrshesvghffhhitghiohhsrdgtohhmpdhrtghpthhtohep
 lhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepphguuhhplhgvshhsihhssegvfhhfihgtihhoshdrtghomh
X-Origin-Country: CA
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

I had an error saying that `regcache_sync` had 2 fields named `type` while using
libtraceevent. This was the format of this event:

	$ sudo cat /sys/kernel/debug/tracing/events/regmap/regcache_sync/format
	name: regcache_sync
	ID: 1216
	format:
		field:unsigned short common_type;	offset:0;	size:2; signed:0;
		field:unsigned char common_flags;	offset:2;	size:1; signed:0;
		field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
		field:int common_pid;	offset:4;	size:4;	signed:1;

		field:__data_loc char[] name;	offset:8;	size:4;	signed:1;
		field:__data_loc char[] status;	offset:12;	size:4;	signed:1;
		field:__data_loc char[] type;	offset:16;	size:4;	signed:1;
		field:int type;    offset:20;    size:4;    signed:1;

	print fmt: "%s type=%s status=%s", __get_str(name), __get_str(type), __get_str(status)

Erase the `int field` type, who was not assigned. This field was introduce by mistake and this commit removes it.

This is the format of this event after the fix:

	$ sudo cat /sys/kernel/debug/tracing/events/regmap/regcache_sync/format
	name: regcache_sync
	ID: 1266
	format:
		field:unsigned short common_type;	offset:0;	size:2;	signed:0;
		field:unsigned char common_flags;	offset:2;	size:1;	signed:0;
		field:unsigned char common_preempt_count;	offset:3;	size:1;	signed:0;
		field:int common_pid;	offset:4;	size:4;	signed:1;

		field:__data_loc char[] name;	offset:8;	size:4;	signed:1;
		field:__data_loc char[] status;	offset:12;	size:4;	signed:1;
		field:__data_loc char[] type;	offset:16;	size:4;	signed:1;

	print fmt: "%s type=%s status=%s", __get_str(name), __get_str(type), __get_str(status)

Signed-off-by: Philippe Duplessis-Guindon <pduplessis@efficios.com>
---
 drivers/base/regmap/trace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/regmap/trace.h b/drivers/base/regmap/trace.h
index d4066fa079ab..9abee14df9ee 100644
--- a/drivers/base/regmap/trace.h
+++ b/drivers/base/regmap/trace.h
@@ -126,7 +126,6 @@ TRACE_EVENT(regcache_sync,
 		__string(       name,           regmap_name(map)	)
 		__string(	status,		status			)
 		__string(	type,		type			)
-		__field(	int,		type			)
 	),
 
 	TP_fast_assign(
-- 
2.25.1

