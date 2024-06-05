Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1091957EB
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594922; cv=none; b=Vr7Jl46Dji+y6hSIu+Snrsb8UJudLXeTCYeCcupQafuQDJ2rNpXBB5yvlJHVek+QyUD+760VNAgKRxAlCxvgyQ9Pp2qYcs3EOcXG/4g2e6GiVabTIPHttQbteAeKoStji1PQxvlyYwk/8TXm1vENfB9Eq15BkXgpKwmaYVBVmOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594922; c=relaxed/simple;
	bh=GKVzg6lq9G0dIXWqfbx87RNmLXU33FysFWJsjHTXWhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RD802RXpHLxpqx5+xwssjfwhO9QJ6EnUfp4nWl6055AAZGjjlky4D8Vu3OBsKAVaN2+BA79YaYs2sHHmC1WRgeCFG8oyfmzKbArCE9o7T+JNYOtRld/O267ZuNSj4UlD8iGD1qzYLkODVzEQO49Wp6MDxbRCcneI2WQEduujnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PRIqG5VW; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PRIqG5VW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594919;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uHLlvnokkk/09xwa0Lk3p1AgBtCROe8Gprobn4fGLJk=;
	b=PRIqG5VW9iTWao3CX6cvfwqrC+VurvcclUd0Wn15ignephe5RyxhZ3uW6rVg/usT0abIF3
	R/0IlMW+xp23qZylMjH43KAWvNOYyziMcyYVccZ42xb2OqxHCCly3uN6ofGr+URTRmIVNL
	qY1kIbP3/JpGw5fFcU91MsxAvzwjCwk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-303-CH3iPDLANrSRwx-bMQhX5Q-1; Wed,
 05 Jun 2024 09:41:58 -0400
X-MC-Unique: CH3iPDLANrSRwx-bMQhX5Q-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E285E1954210;
	Wed,  5 Jun 2024 13:41:57 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 618B319560A2;
	Wed,  5 Jun 2024 13:41:55 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:41:53 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 16/38] trace-cmd lib: don't double close a file descriptor in read_header_files()
Date: Wed,  5 Jun 2024 15:40:31 +0200
Message-ID: <20240605134054.2626953-17-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

In read_header_files(), if we encounter an error after we close the
first file but before we open the second one, the exit code tries to
close it again.

Move the call to close() just before the second open to prevent that.

Fixes a USE_AFTER_FREE error (CWE-416)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 35904620..c270d03f 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -685,7 +685,6 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	if (do_write_check(handle, &endian8, 8))
 		goto out_free;
 	check_size = copy_file_fd(handle, fd, 0);
-	close(fd);
 	if (size != check_size) {
 		tracecmd_warning("wrong size for '%s' size=%lld read=%lld", path, size, check_size);
 		errno = EINVAL;
@@ -697,6 +696,7 @@ static int read_header_files(struct tracecmd_output *handle, bool compress)
 	if (!path)
 		goto out_close;
 
+	close(fd);
 	fd = open(path, O_RDONLY);
 	if (fd < 0) {
 		tracecmd_warning("can't read '%s'", path);
-- 
2.44.0

