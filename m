Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D37C21D596
	for <linux-trace-devel@vger.kernel.org>; Thu,  9 Jan 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736436126; cv=none; b=Nw5Q+BM+GNKxJCGk28TZRkd9sWISfYXwelK7kA2dKPKCwGpJS78fg6hfLG03le1GiFQzRMUJLvjAm6jQDuuOk8+adwg0I529GKMd9NGkSNsjlYOCq/gV31MnBxtL1uDm0AUEj9IuJtVa/W6JDMZPZFmiH2Nm0YjbFQhEQwG58SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736436126; c=relaxed/simple;
	bh=QSs+EPe1tPrz02abXk9WTe1Dk2uHbL6qb3S4/YDpT/E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=kIBBTl6RBrrYtRCsr63y/ln9l/O9azFMSoyQrKmKV1/1OTmwvMh/zrOvLWyLqZ60tF4re4Sw/38uZnor6EIXo88qmk5ZBjFa0NEjkSGIobaFoSTuhQtn7zRGrL7JPioRoE/vK+tMXVFchVjYtG2IK+HJNexGYJL5CglBebFF7zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B718BC4CEE1;
	Thu,  9 Jan 2025 15:22:05 +0000 (UTC)
Date: Thu, 9 Jan 2025 10:23:38 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Shiju Jose <shiju.jose@huawei.com>
Subject: [PATCH] libtraceevent: Return error on event parsing if format
 parsing fails
Message-ID: <20250109102338.6128644d@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

The event parsing should not fail if the "print fmt" portion fails, as
that is just a hint by the kernel on how to display the event. But that
portion can contain kernel internal information that is not available to
user space and there's no way the library can parse it properly. When that
fails, the event printing falls back to simply showing the content of all
the fields.

But if the fields themselves fail to parse, then there's no way to parse
the event properly. This should end up as a failure of parsing the event.

Link: https://lore.kernel.org/all/20250102174317.1594-1-shiju.jose@huawei.com/

Reported-by: Shiju Jose <shiju.jose@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index 33ed7fb47fff..f2e50b0e8992 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -7841,7 +7841,7 @@ static enum tep_errno parse_format(struct tep_event **eventp,
 	ret = event_read_format(event);
 	if (ret < 0) {
 		ret = TEP_ERRNO__READ_FORMAT_FAILED;
-		goto event_parse_failed;
+		goto event_alloc_failed;
 	}
 
 	/*
-- 
2.45.2

