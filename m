Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=216.40.44.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792522203;
	b=CdqWS9J0n0Yelk7nLcbJBWK7O4pG19MbaL78k/PBNrv/BU3TbvoGMwHsJ4OkAPXWhnVG
	 tTFEvh4bOUfkfcwyqxnqt9WgKK70o5sKb9vvsJRBoVFWXKtfcotEXr/4316eOKxdfIdG7
	 aLdhZqjiTnOTVY5evIcpRwE6M0D9JIkeFAaQs0nfOhMOwcFS8rq9Tms9GoM8bLaYHqmIl
	 /vtb3cRRfOKWSGKIaxSS13oUFyqdJOOSWiFf0HWCEzPKbvC8LSw1Fgl3GNkid4+zVWL4Y
	 0JO98psRZ2nI7nuqur+0c7fHjwvGz3qg8hon52eXBN6qjEC80WFFzs4mR5a2zkLmZLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792522203;
	h=DMARC-Filter:Received:Received:Date:From:To:Subject:Message-ID:
	 X-Mailer:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Rspamd-Server:X-Rspamd-Queue-Id:X-Stat-Signature:X-Spam-Status:
	 X-Session-Marker:X-Session-ID:DKIM-Signature:X-HE-Tag:X-HE-Meta;
	bh=ES4ZWfL6Xg3Q2E/yLc/9nBu5ylxilinhBzuME4ZW22Y=;
	b=rEGm0JV4nZGUPsUbcb+57oiOmLdmKzYgpE2JQV6Q1+9PN/6Dj3qpALHhAhKRUhVNNkPP
	 LHF+GQdcx7s17LOJ+s4jfHq6Yrez98GMouwzyBNhI3zF1brKpjt4lXmJP28oYRDf0Yg+t
	 CrZaGF/J9U9ARWArKgWqedVKYf0+QcmZjEv2BW1z5ZgoiZgNNSx2v1UMesBQVh/8UaCJQ
	 CdgZ+/xVL+fUdECFZs1tEqJWIyLOMd5k/NXQqMSFYWftKP1JVM80BR+evRu4RxpWMhXot
	 lhH3YgHTQyptQ4zh3CjWOn4qr3PvhIfFB94e89yXXau7J4bijaC2mte7iOcrV6eZ3Dg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=goodmis.org;
	spf=pass smtp.mailfrom=goodmis.org;
	dkim=pass header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=qFRwUuG6;
	arc=none smtp.remote-ip=216.40.44.16
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76077606A324
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:50:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76077606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=goodmis.org header.i=@goodmis.org header.a=rsa-sha256 header.s=dkim1 header.b=qFRwUuG6
Received: from omf16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 53E12C0361
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:50:01 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf16.hostedemail.com (Postfix) with ESMTPA id 0AB9D2000F
	for <linux-trace-devel@vger.kernel.org>; Tue, 20 Oct 2026 18:49:59 +0000 (UTC)
Date: Tue, 20 Oct 2026 14:49:53 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: [PATCH] trace-cmd record: Have --nosplice memory map instead of
 read
Message-ID: <20261020144953.61d386f1@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Post: <mailto:linux-trace-devel@vger.kernel.org>
List-Help: <mailto:linux-trace-devel+help@vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-trace-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspamout02
X-Rspamd-Queue-Id: 0AB9D2000F
X-Stat-Signature: gb9iyrhqomu8u3gep3tpqyrusphtzemp
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX191vmZtbwRWEjzCPa/Hzf3KDLgBwd9YehY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=goodmis.org; h=date:from:to:subject:message-id:mime-version:content-type:content-transfer-encoding; s=dkim1; bh=ES4ZWfL6Xg3Q2E/yLc/9nBu5ylxilinhBzuME4ZW22Y=; b=qFRwUuG688L27klXp2JiDQoF+SiHG8N1NsLsErDNdUaHsIg+AP5beeGlfouzBgFVrnvYuzrox+b4E6xpEd4IXyGyD9yqoUOLeFHQ6ZwYP37i7WN7CJSQHxMSQypShlgQvWmRWT0qlZl7l+lStoTxu4V8/uWV4hDhTeV+8cmyBYM=
X-HE-Tag: 1792522199-784578
X-HE-Meta: U2FsdGVkX19+wUxQoc1NJEqcevPU9pgm7WRWSniXwW4I9dhfgN+HeGaHcLjEr+FgH34jW+ydLnA4Cgb3KFn4LTVQ0/B/kfZ163c7xhpJu6hrIxkScFFmUB6LMOKzT2iGV4ea8IbCTPDj/M4W0Mui23jnjQoG1BcWgDOr0WQxBVKBJtesUVgMKYC5BXTRvY+KmvwLwtl7FK1EGchWMROv6wCSwjJzC7XBE4uij2+RacI0CrSeG23oNRRG5r+RcaFi5OOipWYmG6ETqNofrS1w9l2liiePhFqvwEqJhCW8/w0bw+ZVn8i3L+kQQ9IzBZDkNtcJ3SkGgHedkOYxOu0WmF7Dkne7NSmLEH0s4aX/lYjv6TRwuidPIQ6LNRJ+xpmZ

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

As the ring buffer memory mapping is now available, have "nosplice" use the
mapped ring buffer instead of reading which makes one less copy of the data.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 lib/trace-cmd/trace-recorder.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 6f146bb61ac0..906fa7f1263f 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -146,6 +146,8 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 
 	if (tfd >= 0)
 		recorder->tcpu = tracefs_cpu_alloc_fd(tfd, recorder->page_size, nonblock);
+	else if (recorder->flags & TRACECMD_RECORD_NOSPLICE)
+		recorder->tcpu = tracefs_cpu_open_mapped(instance, cpu, nonblock);
 	else
 		recorder->tcpu = tracefs_cpu_open(instance, cpu, nonblock);
 
-- 
2.53.0

