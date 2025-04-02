Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60C72D7BF
	for <linux-trace-devel@vger.kernel.org>; Wed,  2 Apr 2025 15:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743606484; cv=none; b=N8+r06lPlrrjM+IlKmMwKUckwM87KnVxpucSURraG7a6qlCM79NSi1Pz1RjnVRAf8hpaor61FJJVrEMhnfxIeJN9pK4dOAcpZKvgdK8cEkdnDWh1so4lM+hUJVeIr0K7wyKfe8owOzcw3JPaWFhWXVQftVHDJ87Z33u9yFmU+Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743606484; c=relaxed/simple;
	bh=KZwI3KrhlYMg3gxZARQOV/+zvDRkEmMOL8HxnuOaEzs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oz/EBtkW1lZXogqCl1UsyhWVkhrZIdzjt47D0LCOL04DxCc8PwNVXlZDjmiBjFf6XTrnZRP4gj2Dr0W/qoviVat27ZDImXTrC/gja5VOb+4DZdjN0VTwTAZMYnutNb4puWnafzG+QFJrzDhJrZjhRprcULf41HMGMyVCilUvOaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nqi2+8xH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nqi2+8xH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743606481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=vkgY25eUitQ4K5LHv9U5VCEmK6qBzDXW2DgtAzLmWHE=;
	b=Nqi2+8xHH/S3VioXhBhmN5TZ4ZKv4BmHoEW8KyhH1vLvni7TgEfC+1mwBWFrZRPIFowlGE
	Z/gquLimt5F5/OuWebwhkXhK1pct+/xC4elczyr2N+xyZstqGBAc9o+ieaRlVhaMrjuLCX
	23d00Dl8xRtWAukphNUgY3fW0EOUMDA=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-640-TUkJnw3hPqiKvHxwIg7Rlg-1; Wed,
 02 Apr 2025 11:07:57 -0400
X-MC-Unique: TUkJnw3hPqiKvHxwIg7Rlg-1
X-Mimecast-MFC-AGG-ID: TUkJnw3hPqiKvHxwIg7Rlg_1743606476
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4C47618001E3;
	Wed,  2 Apr 2025 15:07:56 +0000 (UTC)
Received: from fedora (unknown [10.44.33.152])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id E6387180A803;
	Wed,  2 Apr 2025 15:07:52 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 02 Apr 2025 17:07:51 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH] trace-cmd lib: Copy message buffer content in get_trace_req_args()
Date: Wed,  2 Apr 2025 17:07:51 +0200
Message-ID: <20250402150751.335229-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

The description of  tracecmd_msg_recv_trace_req() calls for freeing
argv[0] after a successful call. However the address pointed by
argv[0] which is set in get_trace_req_args() points to msg.buf, which
is then freed. This cause use-after-free errors, in particular when
the trace-agent free argv[0] as recommended.

Fix this by copying the content of the message buffer to argv[0] in
get_trace_req_args().

Fixes the following error. On the guest:
$ trace-cmd agent
listening on @3:823
free(): invalid pointer

On the host:
$ trace-cmd record  -A @3:823 -p function echo nothing
Negotiated kvm time sync protocol with guest unnamed-0
reading client -110 (Unknown error -110)
nothing
  cannot create output handle

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-msg.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 5739c171..8d15ce07 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -1247,7 +1247,7 @@ static int get_trace_req_protos(char *buf, int length,
 static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 {
 	unsigned int nr_args;
-	char *p, *buf_end;
+	char *p = NULL, *buf_end;
 	char **args = NULL;
 	int ret;
 	int i;
@@ -1267,8 +1267,15 @@ static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 		goto out;
 	}
 
-	buf_end = buf + length;
-	for (i = 0, p = buf; i < nr_args; i++, p++) {
+	p = malloc(length);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(p, buf, length);
+
+	buf_end = p + length;
+	for (i = 0; i < nr_args; i++, p++) {
 		if (p >= buf_end) {
 			ret = -EINVAL;
 			goto out;
@@ -1282,6 +1289,7 @@ static int get_trace_req_args(char *buf, int length, int *argc, char ***argv)
 	return 0;
 
 out:
+	free(p);
 	free(args);
 	return ret;
 
-- 
2.49.0

