Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA1923A1E91
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 15:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306737; cv=none; b=NxGBLKzM7EX+9V1+tEruW82kvqa7KBxUt+NO8Fgr+8PWldSA1qZRng2zcEBtQnwIXdsDOujMZHt/gPvk1tfq0iEZGrMCV9heD3m+mEr9rUS3xPjRP/+TuorgbBn5LmESAQ0WLQGi98m8OFth5yQsxMl4llFOkai7hsFb6CGMDJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306737; c=relaxed/simple;
	bh=EQ8mf0zrEW2UTDwqigOCY8ytICfYk1UPQ5idCaBQiBc=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=giNmBNQhIfRuKyzYezG+X2LAFu/ezwqaUHvvHZ+IDgmFAAkhMch+2Y9oHAsDSwKuYR3HnCXPT/LuISUIo+DuRE57ZeNcJZWnhsOmNmtgrGRVJWpJewZWXIKFpAygncD5WfeSei1TvwpQzakSEdmP1KJeZzWJ2SHqgRUWQh+ImEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4A0FB8BF2
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 15:52:15 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 6C13F20015
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Feb 2026 15:52:14 +0000 (UTC)
Date: Thu, 5 Feb 2026 10:52:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd list: Show parameters of all functions if
 specified
Message-ID: <20260205105249.25233423@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zr3cnce1hptnpdpuzwrfhi3f7mrs9mg8
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 6C13F20015
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+9o2BLpTNspxVZYIMsI0J0TKo/TOAOGNY=
X-HE-Tag: 1770306734-938739
X-HE-Meta: U2FsdGVkX1+AnxGEra+LhdQsx8c46d9FKp2dmB4/Yv1dihsTD6aPPbL4h7iSIzth9+kSakzYCroPH9h+HPjv4gA+dGj6mo4F900xRCtc7qE006tF2/yvFy4OR1S2yU01aSoL0jlBrE6OREfE69R8kX+pRNh1aEj4NBZkWN7fAJN5yL5dy+ain78c9WHjOzUoDiuYM7TXY20bAq71KU55h5L9wtXPAmM6YpleVc4cEYVssQ2auxCwWiAiPc+YF65RHlx1YOwhfW2I0hJhTshmhaO4vmE8Qgvlyt3hcZP8ktarMPB/Q6AfWdThDks47t61e8wmqllLcU9WcBVFamvYzEMpljeJmJRSz81CB2tRbTpYpXzFx3zgYb4qEseKauLj

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Currently "trace-cmd list --proto -f" just dumps the functions without
showing the arguments for them. That's because if "-f" is used without a
parameter the code just dumps the contents of "available_filter_functions".

Have it still show the parameters if --proto is specified with just "-f".

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 tracecmd/trace-list.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-list.c b/tracecmd/trace-list.c
index da2604ed1b2e..21e911999125 100644
--- a/tracecmd/trace-list.c
+++ b/tracecmd/trace-list.c
@@ -529,8 +529,11 @@ static void show_functions(const char *funcre, int params)
 	int i;
 
 	if (!funcre) {
-		show_file("available_filter_functions");
-		return;
+		if (!params) {
+			show_file("available_filter_functions");
+			return;
+		}
+		funcre = "^.*";
 	}
 
 	trace_seq_init(&s);
-- 
2.51.0

