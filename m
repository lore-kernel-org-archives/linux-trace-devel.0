Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD86196431
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688332; cv=none; b=d1Yy0dpxVa++HXeVnK+C5vps64ofmNT6XMAgi4KsqothCDQPN660+pihXPDPnNQYudtY8eFyx0L59sYxJA+9tGh6g3l2rR5MF91tuc48yvjYMQOmqM8xYDvZBGobAYgE093YY0WOufXwLZ3k+jnXiyaYDa8yBqisRSm+hPpkPRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688332; c=relaxed/simple;
	bh=w99eGZVHB3/m1/fKVXKV/Iedx9+G+KUaZZ4KaRSueMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OIiM73F2tRxkWMzd2YWxAppCznAtTnOzNnco/2eFATBgTJUbutwHBw48l+FSlJ5IJZppr2y+wUGnhc3nT4YlGlL70dci+vx4OXo6WSBW7F1IpPCJ57gwyxquMPtyU6bNtexNrDeKi2ZXcgGxTyjin0RxMy4fAlmLAyv6gX5FZMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W0rQIKRR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W0rQIKRR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688330;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Std32kvFskPbELW2vLz8Q7n/5y+g6fqTm3ibXyw4jFs=;
	b=W0rQIKRRbfo691zKI6qZ2XFDojlnPG8CeeKGl+4DCubxAHKsCZyhMrPWEsPSv/FMNaQyFY
	wiXvukmUstBIOR919G+ZaqrSlFFHvQw0rokb5969ZV3CRB8UdpT6JGd9B2Wz368jPigBFL
	muCmuq1r+YKnN5kGQAffttbTRrZeqKQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-MqqbcWurN7-yBt5iLV0S2w-1; Thu,
 06 Jun 2024 11:38:46 -0400
X-MC-Unique: MqqbcWurN7-yBt5iLV0S2w-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B1512196DFFA;
	Thu,  6 Jun 2024 15:38:45 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 597881959178;
	Thu,  6 Jun 2024 15:38:43 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:42 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 04/15] libtracefs: prevent a memory leak in tracefs_synth_add_end_field()
Date: Thu,  6 Jun 2024 17:38:18 +0200
Message-ID: <20240606153830.2666120-5-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Free tmp_var in the error path.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-hist.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 87287b5..4f4971e 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -1576,7 +1576,7 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 	const struct tep_format_field *field;
 	const char *hname = NULL;
 	char *tmp_var = NULL;
-	int ret;
+	int ret = -1;
 
 	if (!synth || !end_field) {
 		errno = EINVAL;
@@ -1594,15 +1594,15 @@ int tracefs_synth_add_end_field(struct tracefs_synth *synth,
 		tmp_var = new_arg(synth);
 
 	if (!trace_verify_event_field(synth->end_event, end_field, &field))
-		return -1;
+		goto out;
 
 	ret = add_var(&synth->end_vars, name ? hname : tmp_var, end_field, false);
 	if (ret)
 		goto out;
 
 	ret = add_synth_fields(synth, field, name, hname ? : tmp_var);
-	free(tmp_var);
  out:
+	free(tmp_var);
 	return ret;
 }
 
-- 
2.44.0

