Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BDD3E51C0
	for <linux-trace-devel@vger.kernel.org>; Fri, 24 Apr 2026 19:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777058133; cv=none; b=E7peHIDdzdvJ2ou+bL56kMagaiycsRokuXB7g/zSDSVXlsT2e8EUUUt3aBPZfzBIQ2uweeOY1DkUv+S1c18g4C75gkKOLW7Pjauftrsa67uSVPVv0uVHcFctlNlyWy60ry822sem3EWUqhaQFdzudzNTTjh/HezGNnfCOhm2x+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777058133; c=relaxed/simple;
	bh=mEaRtYgMrzrpySotqb9K+HgFlFd6fN+rEIX1QI8CmNE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ZVtp/foQkMWQmT/PVj2O1O4vHzVxqL9xjIi3NZ4vhwbTuVjCtXRKi/sIbjySuP1ZPPxaU6Fjah3F7jtkZmwpQSz+mCyhdKC5WEzqPmXvK69PSqvHKFOM0j77LKdamBIkHs7eD0s1BGlsVpX0hN5iF3FMZXZuW0kOXWbuN+auPBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B3321A02AF;
	Fri, 24 Apr 2026 19:15:27 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 16BBE20019;
	Fri, 24 Apr 2026 19:15:25 +0000 (UTC)
Date: Fri, 24 Apr 2026 15:15:31 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Alexander Krabler <code@a.krabler.eu>
Subject: [PATCH] trace-cmd: Fix extracting instance in RO directory
Message-ID: <20260424151531.3c9be298@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 9z36jueoad7jgx8fai7j3kq8ofoumqn6
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 16BBE20019
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18wW+Hrkzn9zvXNXwczxwtf7bo44tEf/xY=
X-HE-Tag: 1777058125-656806
X-HE-Meta: U2FsdGVkX19I4fZ2yjvTyhYdaQgDN4iNbVkXTJXwtR7i7v245a8cTF3Wn+erYoAvZyvOZ4LqyZ0FU3rb1Qfi+d2jkBu7PZPqu/h1gvotYQQiS5oh+feqDXwloKz5GtYbMtZ4nn6epb4GLUyHU5ef8czxDmSLiILC8UQR6bKWRjxFEYb/n/ASHze+/wCnArg8dXR0AtPS3S2fGvtRSm4UrncDOAogiLFGp6mi6oZeNI3rfmyWYNY72QbgwUZmFfRHUvA+za+qCUAnehcDuN3bh4i0dt803ErgGeToaSsgOeL0gpw2n3ouDfDsp+iuNktvzjmubIyjJFv6F3DT0MQDE1oe8+gQep+ba31zyGGsRuTdoKR0k+6ue7Ho55KBVHxQsgjh6bfpZyXGKkgP/ynI2dcnj2Yq8z7kN5c3Z+JgeTW6vl7QBZBRCybrXR1dB6FrI1ko/jf1r/QfC2OM7expdA==

From: Steven Rostedt <rostedt@goodmis.org>

If the extract command is run in a read-only directory like
/sys/kernel/tracing trying to extract an instance buffer, it would fail due
to trying to write one of the temp files in that directory. This is because
extract (and record) still save data for the top level instance (although
the top level instance buffers are not read). It creates temporary files to
do the creation.

Because the top level directory is not used, its instance was not
initialized with an "output file", which is used to know where to create the
temp files for. It then defaults to the local directory, which in this case
is not writable, and the extract fails.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221389
Reported-by:  Alexander Krabler <code@a.krabler.eu>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 1966ec14..e7bb2f58 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -7527,6 +7527,10 @@ void trace_extract(int argc, char **argv)
 		instance->flags |= BUFFER_FL_KEEP;
 	}
 
+	/* Make sure top_instance.output_file exists */
+	if (!top_instance.output_file)
+		top_instance.output_file = strdup(ctx.output);
+
 	/* Extracting data records all events in the system. */
 	if (!ctx.record_all)
 		record_all_events();
-- 
2.51.0

