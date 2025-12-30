Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C4BF1F09A5
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 16:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767112325; cv=none; b=J3TgsBVmQGXx7P9/0zGX+lNMaIjsSoGjn+5hWV/1DFqP3nwNDT05OPiBGeV/MkB+4deXB1ruYidWyMtUS8M6tYpuGO2RmrJC73VwzOPdBt/Rf4gW/jNAvuFkazyZ8joZ7OBp041rQFvNzO8S7vcHl2dhipFvALEOh/qAlKNCTW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767112325; c=relaxed/simple;
	bh=701V1zKB/G9apIIG/WC4QtNJKVZFxlYWpj3GgcTP/ps=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type; b=l0SduyFAxTa7AzkdzkRNN+x5WtGE5fnLpQfQe8IK4dnD8+bLm7QQUl/Nclhe8BB6mMc9vgCNPrSufcGMVvkWKOzh6w/u9riqW7q5zTZREt/0VgzXbQaPZ1Y2OWjVs2vX0XVaBeVWp6TFOnsvWi7EOt0LlIpZQxOx6xNU87vPEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 601E0160264
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 16:32:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf01.hostedemail.com (Postfix) with ESMTPA id 2AB4760011
	for <linux-trace-devel@vger.kernel.org>; Tue, 30 Dec 2025 16:32:00 +0000 (UTC)
Date: Tue, 30 Dec 2025 11:32:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] tracefs: Fix whitespace in enable_disable_all()
Message-ID: <20251230113207.7e523161@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2AB4760011
X-Stat-Signature: 4rwgohnxbe41njp8r3jqaz4gi3o5btse
X-Rspamd-Server: rspamout08
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX183d9vvkGL5ZQL3UGxt9B/snZXtpo+pH1w=
X-HE-Tag: 1767112320-777218
X-HE-Meta: U2FsdGVkX19EqRCoxgK5eXpYP2Ii3JuTImJGarK3HXOXtIsASXQrjnYu/QeMovCAlO2yYiAmBaX38smuJOuWZPBFBdoR8oWN/Cfw15NcFokJAj4ndcV5nJT+53bEt5CMm2Y6s0uy48NKFHERfFZahCu0dii5GfpTf3+sDgXglmbVz27i4m5prf/LjZejx+c324cKymOosNCWO6Q9477r4eunIYrjpBO/fo3c04ujBJrVHgbEkh3la8Xdg+AthA3NKE9aYnnYVHc8NWN5QEMAGgFlNowad9HTY5pAxFCghP7xVkglxrN5xdhSG9GEy5pwd89GFrqYChpWO5IrgcofWkxnSOK3C/0AuC9LKl4C1mZrMoxDA++7P4JVgn/XNTE0

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

A blank line was added in between the else and the next line instead of
after the else block.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/tracefs-events.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-events.c b/src/tracefs-events.c
index aabec0295f4f..5f35569735f7 100644
--- a/src/tracefs-events.c
+++ b/src/tracefs-events.c
@@ -1524,8 +1524,8 @@ static int enable_disable_all(struct tracefs_instance *instance,
 	if (state)
 		ret = read_event_state(instance, event_file, state);
 	else
-
 		ret = tracefs_instance_file_write(instance, event_file, str);
+
 	free(event_file);
 
 	return ret < 0 ? ret : 0;
-- 
2.51.0

