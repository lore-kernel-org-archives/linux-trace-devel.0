Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB75A33439F
	for <linux-trace-devel@vger.kernel.org>; Thu, 23 Apr 2026 20:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776976199; cv=none; b=iiG4Xd6jmVBoAjc/1dl0CPM21ndF2j6MQjDKFW6VnGnk2C1Ul+MvLRg8X2xKZPAaz9DcKuDJLHp4usdWL7oeerJ321555UZtzTaNXxvMvrGUMnr6sQ1TJ0LRR+jfXPeyzuzJU7oU5CpfpxHtHEkXqkmlwlHJQ1PlHQMRsdupc48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776976199; c=relaxed/simple;
	bh=lFrSwKP4oVQ8cn2Hv7ufIB1KrgVT/psdHn8/dLqLzpU=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=OprFWTTHXG2l6/dK+83bloPaDQmcgsUDTCH+5j/KR/2NKL6syLvE0GyNF/iJG9iZS3JUEjmRm84vHcH1AJWXx9J/RJEfsYbJOeMCWQmXph7X91Cpv8NYa2Mfpi5NRITYW3C5FGNqo5j90EHI+Ews0uS+wrW32emIE9mOAzHuYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 428094030A;
	Thu, 23 Apr 2026 20:20:53 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf17.hostedemail.com (Postfix) with ESMTPA id 8C9A61D;
	Thu, 23 Apr 2026 20:20:51 +0000 (UTC)
Date: Thu, 23 Apr 2026 16:20:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Metin Kaya <metin.kaya@arm.com>
Subject: [PATCH] tracefs: Fix tracefs_dynevent_destroy_all()
Message-ID: <20260423162054.3fd36a5c@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6b4yk8qcbtkj7a614apyoc3wbx1wswoy
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 8C9A61D
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+xmLVDKD00stRGvOhg9xSgpSk6ejglkgg=
X-HE-Tag: 1776975651-851204
X-HE-Meta: U2FsdGVkX1+u80olZtk8Ufi0li7ZD3J8/5aQPvfDHd2FR57pcMXDYa6TJ/zua6KOavNv8BFgAun0CI9znQbfm2nbCYuC3tFp8Q33SM/EeUvuRuR6F57oHJJgosHsR/s/NeN3zjT4P2rWjHSZoTCFU7qm3xjj5KRRX2Ca5lbvOamL0uu0iAIrc28ppR6tOOMz1UMVZ0k6V62pCCdb3FCwRk5KjPqVckTnJmZzPkqcx/O/teGO9HJqIvAr9VYYpuyHTkAwe69mIUVoqb2aKxxz9/UWdEvOBv0Augw+4Axitfi7V0bwn/L4g6fSEs7584+F4t2ii7JowadY7oRpqo4jaVTd85gmmdaFwkqUHUAjVjlGFUFzGaim9e1WsHavrBwHXJdibMM+8RR1+SS4wGzfY76Sq5/9omJwzFyIrtLLFGa9HH1eDSD979dszUFu4R7Wbzfnbxb1bcbTOJGFyMZJKQ==

From: Steven Rostedt <rostedt@goodmis.org>

There was a regression with tracefs_dynevent_destroy_all() where removing
kprobes (or other dynamic events) if it checks another event that doesn't
exist, it returns zero and not the current count. Then the "all" clearing
thinks it didn't find any events and returns without doing anything.

Have get_dynevent() return the current counter if it doesn't find events and
even if the tested for event file doesn't exist. As that tested file may not
be the dynamic event we are interested in.

Reported-by: Metin Kaya <metin.kaya@arm.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=221395
Fixes: 78d8d2e277af2 ("libtracefs: Have tracefs_dynevent_get_all() find kprobes and uprobes properly")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 src/tracefs-dynevents.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/tracefs-dynevents.c b/src/tracefs-dynevents.c
index 5fdb723b6825..ad879ecbbc68 100644
--- a/src/tracefs-dynevents.c
+++ b/src/tracefs-dynevents.c
@@ -499,12 +499,12 @@ static int get_dynevent(enum tracefs_dynevent_type type, const char *system,
 		return -1;
 
 	if (!tracefs_file_exists(NULL, desc->file))
-		return -1;
+		return count;
 
 	content = tracefs_instance_file_read(NULL, desc->file, NULL);
 	/* File exists, but may be empty */
 	if (!content)
-		return 0;
+		return count;
 
 	if (ret_all)
 		all = *ret_all;
-- 
2.53.0

