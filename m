Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6589194A74
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594968; cv=none; b=HxY+7pv8W8yzoUTbQkT+ApocjI2YjaTEhbkQy+Ck/IDL0Es7nB0c+Wk6PDgDojJHuEFIcUHK2Uuggkyehl4evXy/vVFShoo+IwHWcg7+4wSUMWPaYqcrZSkS+HrZkdMFm9MQxgJTCi/4IgN+pqgHCGe7vSUr+E7MI04vPdmWMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594968; c=relaxed/simple;
	bh=u5ETIK3Yq/id9GNfDZ+x8oyWayW+n39oCs1w9h6g1Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QIsb+H/FikvuybBTD1ztf2w3XFbEeA8I2mvR5OMXeY3m8sJc+D+gbIFzw3c+XVTT+d875WIyQRI0nw4e8aee3mG7iGT4c5T60xQdlCpVxflWvK2qgHg44IGr9VqngH24SIq5N/tpgVwpNzMoAkzu1ugrUOm1T4u1c1DJSHnuPZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FBwL5ecW; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FBwL5ecW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594965;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YPX1++GmcnJREoAy6xVC/uQn5dUL/rATh/cyPgdz9wg=;
	b=FBwL5ecW8xfKiICgatruRhafle5Yh3cbAb8KLA6mg54hYlNuW6wIj1skV0BdRbOCNDQHVN
	ypHu2U2yT46jTSsMdn9UNqyLgOU9zrKerRnkHYeKyndmEWtAOvcTal9RRyBM97G/wK5CiB
	1OPnD5u59HRKPWmv5R8p5ZJ0gIWuPRI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-ZWC_Cj8AOLWqMgAHIeIzuA-1; Wed,
 05 Jun 2024 09:42:42 -0400
X-MC-Unique: ZWC_Cj8AOLWqMgAHIeIzuA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CCD061955D6E;
	Wed,  5 Jun 2024 13:42:41 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 67A751955DD0;
	Wed,  5 Jun 2024 13:42:39 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:37 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 28/38] trace-cmd lib: remove unused tracecmd_parse_cmdlines() function
Date: Wed,  5 Jun 2024 15:40:43 +0200
Message-ID: <20240605134054.2626953-29-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Static analysis warned about a possible use-after-free error in
tracecmd_parse_cmdlines() sscanf() fails to match both items. However,
the function seems to not be used at all si we might as well remove it
entirely.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-util.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index a4334a98..37caab45 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -135,23 +135,6 @@ bool tracecmd_get_notimeout(void)
 	return notimeout || debug;
 }
 
-void tracecmd_parse_cmdlines(struct tep_handle *pevent,
-			     char *file, int size __maybe_unused)
-{
-	char *comm;
-	char *line;
-	char *next = NULL;
-	int pid;
-
-	line = strtok_r(file, "\n", &next);
-	while (line) {
-		sscanf(line, "%d %m[^\n]s", &pid, &comm);
-		tep_register_comm(pevent, comm, pid);
-		free(comm);
-		line = strtok_r(NULL, "\n", &next);
-	}
-}
-
 void tracecmd_parse_proc_kallsyms(struct tep_handle *pevent,
 			 char *file, unsigned int size __maybe_unused)
 {
-- 
2.44.0

