Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C571721A425
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:44:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409893; cv=none; b=P3iJ34DuZRB25v3I7lRC5CzHIPVxJVxNcq/gDXFHL1DE62fRZQ6GIapIpOqODNejXMAMmkaEUDSeDoj9ybrbI70BX5gv0sjWYucWGlzK5hxhv5AMw8hNhk13trJRmXzU45QYd3/CaPEdqMuZYjwj3roapaREI+QTuXXi+tRAevI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409893; c=relaxed/simple;
	bh=LNTBPI4qhZjU247NBs/Kawm8d26TEV5IZFt+9m4gldw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEsOqkAVPZx6a9I7BARt8fX+YPya5J9DHCBdgoCwVpcxBsR6nYUybZBHB2LnPVSpY/RzFyCoFwejN5HhZDW7Luxw+V3Ce/vdTSKUID8nq3+y/I9x/51IgmxymUzNe5Kpa8U2iExX3pRa7qfRNXOAq5ITzhuVJLapQ3q1d3YPAU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=euL0KLqi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="euL0KLqi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CO7Y3KtmbPPvuAQClnYv6sWy/tOG1wP6roOxWjVl7jc=;
	b=euL0KLqiLSmHl7WOe8Ibt4fMez2J0a0O+GTZVNflDvmwejyUBS4nSgk17ukrZq0JE/1yW9
	H23+q8UMtbBtaRrYqYqDSEcv5u0qinj30U+miai5IOWh/Ww24EhedSFJNx5KKrgQSkLPsf
	fE+muYpUlMQwXtgQOPm9QAAU/6r0ncs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-110-EcwohR0YMqWnYvd1sgoorQ-1; Thu,
 05 Dec 2024 09:44:47 -0500
X-MC-Unique: EcwohR0YMqWnYvd1sgoorQ-1
X-Mimecast-MFC-AGG-ID: EcwohR0YMqWnYvd1sgoorQ
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C8CDD1955F2D;
	Thu,  5 Dec 2024 14:44:46 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id AF654195609F;
	Thu,  5 Dec 2024 14:44:44 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:43 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 1/7] trace-cmd lib: Close FDs in create_buffer_recorder_fd2 it allocation fails
Date: Thu,  5 Dec 2024 15:44:33 +0100
Message-ID: <20241205144439.127564-2-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

The behavior of create_buffer_recorder_fd2() wrt closing the file
descriptors is inconsistent. They aren't close if the function fails
early when allocating recorder, but they are closed in
tracecmd_free_recorder() if it fails later.

This cause use-after-free access when the caller tries to close the
FDs afterwards.

Always close the FDs in create_buffer_recorder_fd2() when it fails and
stop the caller to close them themselves.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-recorder.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 44f245d5..0413e529 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -114,8 +114,12 @@ create_buffer_recorder_fd2(int fd, int fd2, int cpu, unsigned flags,
 	bool nonblock = false;
 
 	recorder = malloc(sizeof(*recorder));
-	if (!recorder)
+	if (!recorder) {
+		close(fd);
+		if (fd2 != -1)
+			close(fd2);
 		return NULL;
+	}
 
 	recorder->flags = flags;
 
@@ -204,12 +208,8 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 	}
 
 	recorder = create_buffer_recorder_fd2(fd, fd2, cpu, flags, instance, maxkb, tfd);
-	if (!recorder) {
-		close(fd);
+	if (!recorder)
 		unlink(file);
-		if (fd2 != -1)
-			close(fd2);
-	}
 
 	if (fd2 != -1) {
 		/* Unlink file2, we need to add everything to file at the end */
@@ -257,10 +257,9 @@ tracecmd_create_buffer_recorder_maxkb(const char *file, int cpu, unsigned flags,
 	free(file2);
 
 	return recorder;
- err2:
-	close(fd2);
  err:
 	close(fd);
+ err2:
 	unlink(file);
 	goto out;
 }
-- 
2.47.0

