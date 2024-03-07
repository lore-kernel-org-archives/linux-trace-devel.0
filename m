Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC62F82D9C
	for <linux-trace-devel@vger.kernel.org>; Thu,  7 Mar 2024 12:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709813995; cv=none; b=A7tWVoj4kYhV/j/2C1jWkx/T6ORE81+yX3S1Jq00UqpprpZDvYZmPMxNnx+BX26xdVG3i6Zpyu2CX+hHpXnZaGexeZJaAnZPFSAeAdID9vtU/OFiaLZsTxDvgviuzm375Tepn+TdwpgEBmmZa+d31suosalqhqzWQsLkLTncSnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709813995; c=relaxed/simple;
	bh=ZnWoBWMBziRvZhkYDLZM5mLgvPXrGsjPu5fNDm7EYt0=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=kCaoY2GnhBd2t+PQ7SAR3dtDxKrM52RiljqVxrS16rX5w9n/uJZy7GhwFI52uuBnr8goTkT/L6NS9mMjpQttweMwgW998zX3BjGx2ig1WAHjpVgwIsqhlPkaz+uSXXET05A9Q//V4od9CzSiNAIIXUfYNms50tflaD4Qbof25MI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZFZ/AIep; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZFZ/AIep"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1709813992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=acBJfwVXGzL+jgzGMgw8+rTQ1vgLpDLdDG4zhGVpR70=;
	b=ZFZ/AIepsS6lpcsrZkYcMTPhwXJrxlDuJI/UFUXoNpPSWWbim2o4OWb9a6AeJtn2w3nvN8
	q3mDY7Zs0JHAaEufGp2gXbXrpzZP0Xd4Je2i5GHLUReGMoTY+O+6brkevP9qXmmcL1rGhI
	elo/rIgeEhUZ28ZvqvTt+b+rA3B/XMc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-M0pj_uGcMrSR5yIKE9sIJg-1; Thu, 07 Mar 2024 07:19:49 -0500
X-MC-Unique: M0pj_uGcMrSR5yIKE9sIJg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 26A16101A552;
	Thu,  7 Mar 2024 12:19:49 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.5])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id D2068492C28;
	Thu,  7 Mar 2024 12:19:48 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id 4E66E401D195F; Thu,  7 Mar 2024 09:15:28 -0300 (-03)
Date: Thu, 7 Mar 2024 09:15:28 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Junyao Zhao <junzhao@redhat.com>, Nini Gu <ngu@redhat.com>,
	linux-trace-devel@vger.kernel.org
Subject: [PATCH] trace-cmd: support -m parameter for virt instances
Message-ID: <Zemv4OUx1WexdrlB@tpad>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10


Take into consideration the value passed in with "-m",
the max size in kilobytes that a per cpu buffer should be,
when reading trace data from guests.

This allows one to prevent running out of diskspace on long runs.

Reported-by: Junyao Zhao <junzhao@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index f2cf8dc8..2d14ed7a 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -370,7 +370,7 @@ enum {
 void tracecmd_free_recorder(struct tracecmd_recorder *recorder);
 struct tracecmd_recorder *tracecmd_create_recorder(const char *file, int cpu, unsigned flags);
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags);
-struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd);
+struct tracecmd_recorder *tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags, int trace_fd, int maxkb);
 struct tracecmd_recorder *tracecmd_create_recorder_maxkb(const char *file, int cpu, unsigned flags, int maxkb);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct tracefs_instance *instance);
 struct tracecmd_recorder *tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags, struct tracefs_instance *instance);
diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0633edf5..44f245d5 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -175,19 +175,46 @@ tracecmd_create_buffer_recorder_fd(int fd, int cpu, unsigned flags, struct trace
 
 static struct tracecmd_recorder *
 __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
-				  struct tracefs_instance *instance, int tfd)
+				  struct tracefs_instance *instance, int tfd, int maxkb)
 {
 	struct tracecmd_recorder *recorder;
-	int fd;
+	int fd, fd2 = -1;
+	char *file2;
 
-	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
 	if (fd < 0)
 		return NULL;
 
-	recorder = create_buffer_recorder_fd2(fd, -1, cpu, flags, instance, 0, tfd);
+	if (maxkb) {
+		int len = strlen(file);
+
+		file2 = malloc(len + 3);
+		if (!file2)
+			return NULL;
+
+		sprintf(file2, "%s.1", file);
+
+		fd2 = open(file2, O_RDWR | O_CREAT | O_TRUNC | O_LARGEFILE, 0644);
+		if (fd2 < 0) {
+			close(fd);
+			unlink(file);
+			free(file2);
+			return NULL;
+		}
+	}
+
+	recorder = create_buffer_recorder_fd2(fd, fd2, cpu, flags, instance, maxkb, tfd);
 	if (!recorder) {
 		close(fd);
 		unlink(file);
+		if (fd2 != -1)
+			close(fd2);
+	}
+
+	if (fd2 != -1) {
+		/* Unlink file2, we need to add everything to file at the end */
+		unlink(file2);
+		free(file2);
 	}
 
 	return recorder;
@@ -242,7 +269,7 @@ struct tracecmd_recorder *
 tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 				struct tracefs_instance *instance)
 {
-	return __tracecmd_create_buffer_recorder(file, cpu, flags, instance, -1);
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, instance, -1, 0);
 }
 
 /**
@@ -255,9 +282,9 @@ tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
  */
 struct tracecmd_recorder *
 tracecmd_create_recorder_virt(const char *file, int cpu, unsigned flags,
-			      int trace_fd)
+			      int trace_fd, int maxkb)
 {
-	return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, trace_fd);
+	return __tracecmd_create_buffer_recorder(file, cpu, flags, NULL, trace_fd, maxkb);
 }
 
 struct tracecmd_recorder *tracecmd_create_recorder_fd(int fd, int cpu, unsigned flags)
diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 91cc90d4..69ea0cbd 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -3584,7 +3584,7 @@ create_recorder_instance(struct buffer_instance *instance, const char *file, int
 			flags |= TRACECMD_RECORD_NOBRASS;
 		else if (!trace_vsock_can_splice_read())
 			flags |= TRACECMD_RECORD_NOSPLICE;
-		return tracecmd_create_recorder_virt(file, cpu, flags, fd);
+		return tracecmd_create_recorder_virt(file, cpu, flags, fd, max_kb);
 	}
 
 	if (brass)

