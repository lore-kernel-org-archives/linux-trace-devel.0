Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA2E340401
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Aug 2026 21:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787866949; cv=none; b=sXq8dKj7QsWS26tEBT2q8tzs9PxxNBugoUlteaTeJP86kN7BTZ8maVSrUduRFKs4dQTRhDs4sSBnlQDEABnGq+vAvrIbAZ73E8ZLrPsbVWS7GFzxD1dee1ckE5zM4X71ZY6bznvUW6gC94tdwMqBtN+dv2ZZKcZXE9gq5rQgcKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787866949; c=relaxed/simple;
	bh=29ijSAFWeIh5Wv5iZ5Bl1cqN1apiVgGY82o35VlnysA=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=jWipJxOomoSRJ1+uFHWTtWlaRTO5gEORgvqspMqRRNS/h3TkdsibR3VzPDkpAIFlnCM/9ye89yNtxWCQtxOt3+XQzYeS/aEmPeuIy3h1xecHyFOaXN3bnVcdKB2kEi3uPyzeewzhZbuv8AzILwHdEh+PUUId8B8DCX4lmkmfJAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b=051hh/mp; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=goodmis.org header.i=@goodmis.org header.b="051hh/mp"
Received: from omf06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7D7641401DC
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Aug 2026 21:42:20 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf06.hostedemail.com (Postfix) with ESMTPA id 2E4EC20017
	for <linux-trace-devel@vger.kernel.org>; Thu, 27 Aug 2026 21:42:19 +0000 (UTC)
Date: Thu, 27 Aug 2026 17:43:07 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Do not delete existing instance
Message-ID: <20260827174307.601e5643@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 2E4EC20017
X-Stat-Signature: rg7uk8by3nwj3gi3t9rbahqbt7khzdmj
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18Slcd1dWUw9/kT/firFOCrY4e6305/QMU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=EIhiDAjnetinIxsW9lh4REHHsDSrii8Smisruhc8uyk=; b=051hh/mp7/xCMVxtDbFMfVmA9J7o+KCT+QY4lfzvHrlUCcTgaTDWxOD8cSdpIaaemXp0j4SDyAPJrQpea7xmGqPt/GAEKFL6aRWe69oppgHz7SQlgTRuLYsobxN4wl5SrGtCqChD3KC5hUazEpNWfh6LR9CRAVYNFpqHFo/PxM8=
X-HE-Tag: 1787866939-744913
X-HE-Meta: U2FsdGVkX1+v93/6rLbudYzl5GUDcOieHBhEKLcJt7bc/U6LRa9EoHyhTpJ1vnwRftweT4Hl4J04brifw+xmUR6/wBhFUbdDdgevACqLIpywR+QFvjmVLPARfL+Vi/G8OwlngcTU6O3LohGLCxskZ8vSmboG3q7bpoB4VDQLCIaeIO9DmqfdNd6MtrJPtrRJT2eucCe++XdAJnwkZTgQi2gkzWY0t/iJuTus/csjCcaHQp2ZbRqDlIszTdOXcJNYNNRDGCLuxxp5ZchMX5R00ujSABXnobLGFWhpQBcR2WiQe8buqAkBScMfIY9wyKtGq3E9bNYTRFDXe8omJzvQ6sKzi2D/vmaDCpSrfsh24CpUQxOCmgGGGZhl5JwbLixg

From: Steven Rostedt <rostedt@goodmis.org>

When trace-cmd record uses -B on an existing instance, it deletes it when
finished. If the instance existed when the record started, it should not
delete it when finished.

Fixes: 49b36d72b4d16 ("libtracefs: Combine allocate and create APIs into one")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tracecmd/trace-record.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index e7bb2f58ac4d..1ee3effca114 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -384,6 +384,7 @@ struct buffer_instance *allocate_instance(const char *name)
 		instance->tracefs = tracefs_instance_create(name);
 		if (!instance->tracefs)
 			goto error;
+		instance->flags |= BUFFER_FL_KEEP;
 	}
 
 	return instance;
-- 
2.53.0

