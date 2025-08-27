Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BE74438B
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756334395; cv=none; b=sx/gGJ0TFd4ExaQ79gX8yssfNrfZFMQO5Qo8vgGfbg34cJL1WNk7ZaYWkxI1CL9rk8MSnPr5zafZ4hoMOtranXeazo4tRKzYuIK0F9aPkBpREo/72aCcb1KewIneIti1dFC8xPTGP+QVfe2MRUaWJfpyL3BVYd674uHcB4Aa5aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756334395; c=relaxed/simple;
	bh=V0EOPANh5dRgCHMaM4z6Cge0hnCBwXrY7aTHfWc/UZk=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=oFOvnHJ8q0ovinDgek+T4S6B/7PxsXLwSvIAQ6fXPV38oEqoDeGy8HZbHV/12cf+lfIsfJ1uuBv5LSdbgPt4mY86iSdgvXFvdLP0UtNS8UuzmzqIUGvDsqR7hj8NdKec1X4cD0azUVxOCPUKpzvHEn0wxzm4Xz8rA/JHHMePHw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C16FC08B3
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:39:46 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 0CE192000E
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Aug 2025 22:39:44 +0000 (UTC)
Date: Wed, 27 Aug 2025 18:40:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] libtracefs: Make comm field a string
Message-ID: <20250827184003.17c63731@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: u8taose7kcqs7ufu19bg581smtufwjzw
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 0CE192000E
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19bxYcf3b4cnKcCB/K//6GAx43amZR7i/o=
X-HE-Tag: 1756334384-825702
X-HE-Meta: U2FsdGVkX1+D26R34RC+k14niEQIcgkXB31B6ALFi4/+p0Qbe8w9/LktpXqwBuZsiEkne7OLVJblFiigdH/ODDSBeuBY0JuG455sEOfr0Ai4r8ebMMH1ujs3mcbjqr0VWDCM8tWX6VQdgPCkBSo+45lG7mgrDyA4vLp54idXFP+ld0cJZ7lfVdNIhzurPJrWG50D+8yMlVBlWZSE5j8mBMoik3nnc9jaYxnDDrVTJ07DIFD9zdAWi/asAU1bHlqlQzPyO/9q6P1OetszHp+Ut8zI2GDTNtZfsKWfgfCVSOtcjZrecDtlbj6/783hYZRw/XYIQERdxK39g7tzE2EUA7faN3qd7/7oglzJnMJt52wW/Bvk2UJn8Spv1NFy1JiV

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The COMM or comm that is used in filtering and creating synthetic events is
a string, but it isn't defined as such when it is created. This limits how
creating synthetic events with COMM can work.

Without designating COMM as a string, the following:

  sqlhist -n hello select start.COMM from sched_switch as start where start.COMM = '"hello"'

Errors out with:

  Failed creating synthetic event!: Invalid argument
  select start.COMM from sched_switch as start where start.COMM = "hello"
         ^
  ERROR: 'start.COMM'
  Field 'COMM' is not compatible to be compared with the given value

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-filter.c b/src/tracefs-filter.c
index 3b0933f..b7d050b 100644
--- a/src/tracefs-filter.c
+++ b/src/tracefs-filter.c
@@ -39,7 +39,7 @@ static const struct tep_format_field common_comm = {
 	.type			= "char",
 	.name			= "common_comm",
 	.size			= 4,
-	.flags			= TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC,
+	.flags			= TEP_FIELD_IS_ARRAY | TEP_FIELD_IS_DYNAMIC | TEP_FIELD_IS_STRING,
 };
 
 const struct tep_format_field tfs_common_stacktrace __hidden = {
-- 
2.47.2

