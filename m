Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB3195FE4
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594874; cv=none; b=N01GcHBQrjH/B1jyiZB00wGhaQ2HY1jkic+fi8w9BzLgaysqS7tujjeBM1gZkbYf5nHO16opSZDRAXaxprykaRpzH346d17EpJfqiPPfQfrOKzJmljpneWnMoemUgPNg6JrQH05HEYHBXhA0xduvtdUuJRJA2rd1dfA2srzG/lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594874; c=relaxed/simple;
	bh=O4PJMMqyGKFigLXli0H76Ma27Bi8cFo6ZSankqUUVqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XQPgfOz+NvE33hPfM76ZzCviMyU7WFlXk8nhm86pRlY4kbyzv2PjFjksVLngNJkgDQ5IwA24dQVjZr1h4lfeCzNye3sIb0G7Hr9yrHFvyuJhu1b3JbnFmrOPQAW+tPnU6mZpgF0bULw2SOFJaGYKuuEeKBByWerUZlRhWZbj+2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d05IEX4R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d05IEX4R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594872;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZMUUdJmHdsZIUgCcBsI+CMz60m+gIRuaFqHSTUGioZ0=;
	b=d05IEX4RBy0zK2jGDpnycVyAH45yLDl7JBbFYE1jAfCFmMFjArLoEv4E3VMnbzalr9JJ0f
	cLjGprxnSpyn/ijdJm/TillcSkgkPwK9GP2bBn/MQGxjJoRDMWrYWGhHlnL54yRIYXfm76
	3JwHZe30C9aD/eRk5cq1Hm0ZGABk0k4=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-VNUOPQHsPcKaOoBv5qrW2w-1; Wed,
 05 Jun 2024 09:41:11 -0400
X-MC-Unique: VNUOPQHsPcKaOoBv5qrW2w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C28951953966;
	Wed,  5 Jun 2024 13:41:09 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 58D0E1956055;
	Wed,  5 Jun 2024 13:41:07 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:05 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 03/38] trace-cmd lib: prevent a memory leak in read_header_files()
Date: Wed,  5 Jun 2024 15:40:18 +0200
Message-ID: <20240605134054.2626953-4-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

In read_header_files() path is allocated a few times by
get_tracing_file(). It isn't freed in multiple error paths. Free it
whenever needed.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index eee847e3..59498edc 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -644,8 +644,10 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 		flags |= TRACECMD_SEC_FL_COMPRESS;
 	offset = out_write_section_header(handle, TRACECMD_OPTION_HEADER_INFO,
 					  "headers", flags, true);
-	if (offset == (off_t)-1)
+	if (offset == (off_t)-1) {
+		put_tracing_file(path);
 		return -1;
+	}
 
 	out_compression_start(handle, compress);
 	ret = stat(path, &st);
@@ -671,23 +673,23 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		goto out_close;
+		goto out_free;
 	}
 
 	/* unfortunately, you can not stat debugfs files for size */
 	size = get_size_fd(fd);
 
 	if (do_write_check(handle, "header_page", 12))
-		goto out_close;
+		goto out_free;
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
-		goto out_close;
+		goto out_free;
 	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
 		errno = EINVAL;
-		goto out_close;
+		goto out_free;
 	}
 	put_tracing_file(path);
 
@@ -698,21 +700,21 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-		goto out_close;
+		goto out_free;
 	}
 
 	size = get_size_fd(fd);
 
 	if (do_write_check(handle, "header_event", 13))
-		goto out_close;
+		goto out_free;
 	endian8 = convert_endian_8(handle, size);
 	if (do_write_check(handle, &endian8, 8))
-		goto out_close;
+		goto out_free;
 	check_size = copy_file_fd(handle, fd, 0);
 	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s'", path);
-		goto out_close;
+		goto out_free;
 	}
 	put_tracing_file(path);
 	if (out_compression_end(handle, compress))
@@ -724,6 +726,8 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 
 	return 0;
 
+ out_free:
+	put_tracing_file(path);
  out_close:
 	out_compression_reset(handle, compress);
 	if (fd >= 0)
-- 
2.44.0

