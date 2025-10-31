Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF242EAB6F
	for <linux-trace-devel@vger.kernel.org>; Fri, 31 Oct 2025 15:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761926080; cv=none; b=jr4AerRYVPEZdL+S7gJ2SWz94/ipbwiqLGK8+bxuD5kxtvbwvBGHJWAfg0Ngdo4SfT1vo4X86tB9gGbyZ8xwdwebhbk9VwldwO7kIXF9Ls97cdEFPZOIC0sESG2OZXJUrAGA+dTnaDCCCI+MM4QvOYcOQf+da8WCD0sK7RC4rYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761926080; c=relaxed/simple;
	bh=lnYUOC6gUCqR8Jintp7b9OLB0Osye+DQUKp/GV+XKos=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=eAzmoYFqIZHnqci2K3KDud+m58wQhV3yC3cxjgl6RswQylthudRadUzrgg9cRDl+fMHaAZM3B4InkC1AU7EpRiu16veIN9nhPNXSbkS/Al1aEPlPT7Vew9gnikgZ6OB/p4bDhH7FiGapBv6bGiBDXHu/6LMWFzwwgkwYjZdzo4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F1B5160538;
	Fri, 31 Oct 2025 15:54:31 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf13.hostedemail.com (Postfix) with ESMTPA id 83BB020013;
	Fri, 31 Oct 2025 15:54:28 +0000 (UTC)
Date: Fri, 31 Oct 2025 11:55:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Yordan Karadzhov <y.karadz@gmail.com>, Jorge Merlino
 <jorge.merlino@canonical.com>
Subject: [PATCH] Documentation: Update latency description for migration
 disabled
Message-ID: <20251031115513.41b86970@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4owo64hzdxibcnddpewn5er8hgkqhpd8
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: 83BB020013
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18AQUlsQiSq1rqIDOaZbjgFKiDQFxCwTvI=
X-HE-Tag: 1761926068-105704
X-HE-Meta: U2FsdGVkX1+W0rbQZtvTad9dFy7YDfkcOyvsvaNRu5zr5ZPcam94NbQ3rStKWUY1DmZwhHT1N9lJCHWE1KcvxZjgLWBnxxoqi09WQrTfyj7w/IB1Vat1rEPrj5tC1z8WrwQ+p+fzfxOGoDuEQ7VevnvYifbn0RTcGKQPilM7yBgmgRHHjtOrGR9PiI++N39IPJWZxUYELYtZMMqjDhXf2uBzxjahoLEjEvmHmo4gR/Auv1a8gnsRqcYEsliCfD9gBwT2Db21C8VIClbLsTfbRoe5Tj+8yqGr7UYV18d4/Pd0kqzcrydjc2FTCa1Mk7+31FSJAdr0SNVI91pEEapsqxCijIrV3Uy/DutXLeG3EXm3VzdN+eIWC75hUGT21Jdx0Dyabn4jByQrBWzH0wLdLOltQ1iXUP+8qVkX2OZ33+A0a5+86ftcipqcGUjz3Fkm26QvQTO2NZnn86nGclBjAQ==

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Starting in 5.11, the Linux kernel implemented a "migrate disabled"
counter for each task. When the counter is non-zero, the task will be
temporarily pinned to its CPU. This is useful for accessing per CPU data
that is protected by a per CPU mutex. The task can still be preempted, but
it must not leave the CPU. When its "migrate disabled" counter is greater
than zero, it will not migrate.

The latency field of the tracer now shows this number. Updated the
documentation to explain it.

Reported-by: Jorge Merlino <jorge.merlino@canonical.com>
Closes: https://lore.kernel.org/all/fe35c5eb-7132-4203-9d6f-0a8272b114fa@canonical.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 Documentation/HTML/index.html | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/Documentation/HTML/index.html b/Documentation/HTML/index.html
index 7dac810bebbd..281307735289 100644
--- a/Documentation/HTML/index.html
+++ b/Documentation/HTML/index.html
@@ -353,7 +353,7 @@ The columns of the list are:
 resolution.
 <li><b>Task</b> - The name of the process that was running when the event occurred.
 <li><b>PID</b> - The process ID of the task that was running when the event occurred.
-<li><b><a name="latency">Latency</a></b> -  The latency is broken into 4 fields:
+<li><b><a name="latency">Latency</a></b> -  The latency is broken into 4 or 5 fields:
   <ol>
     <li>Interrupts disabled - 'd' if interrupts are disabled, otherwise '.'
     <li>Need reschedule - 'N' if the kernel was notified that a schedule is needed, otherwise '.'
@@ -365,6 +365,12 @@ resolution.
       than zero, then the kernel will not preempt the running tasks, even
       if a schedule has been requested by some event. If the counter is zero,
       then '.' is shown.
+    <li>Migrate disabled counter - Starting in Linux kernel version 5.11, a task can
+      be temporarily pinned to the CPU. For accessing critical sections that are protected
+      by a per-CPU mutex, the task will need to stay on the current CPU. A "migrate_disable()"
+      call is performed that increments the task's "migrate disabled counter" and will pin
+      the task to the CPU. If the kernel has this feature, this number will be displayed
+      as the 5th argument when it is not zero. Otherwise it will be '.'.
   </ol>
   <p>Note: These may be different depending on the kernel the trace.dat file came from.</p>
 <li><b>Event</b> - The name of the event.
-- 
2.51.0

