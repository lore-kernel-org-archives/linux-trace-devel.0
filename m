Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B3E7200BA5
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188890; cv=none; b=inXq3PRupri0nri8DKdp3PrX5+PdsYxV1FyYNSoZ9v0R3jvJGXdLyeD8qiZGTOMldNw5ZjcFbZzZcAVuUkff60/ggtf/3VN2zwDB1POXiPzx7KwIOXLxv938ZSeFcUOk2tCm58mvjAlZUL+MfwhTJn4RSoZTZf0HH2+BQ8ytxN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188890; c=relaxed/simple;
	bh=giqtZqw4g3bgGEGBGB08tsN55IgWP62BpYVg6BGefaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I6axNY24BDzAtraClxz2IQ9yUuCdbRVLehqZwGUW0ZHuFXRHuHd4RXyK5B2FNgReQ3gCIuLkrJUcm4XaUetpD/Gt52LjmSN4y3VTX4PBpqHccBiri1PiWuBnSkrU1GXiIcV914d2I9G9piyUdq/2E1k4bNHCYrEri1+13nyZ2F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gyGZbO98; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gyGZbO98"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ey5HutQo4jyas6zbbnfyt7g7vlMu5o7vz3BFdixFL4A=;
	b=gyGZbO98wBRCzO3f8qCAnirZpPRLymcmIEzQyGKv1eLR062IuH0bAzjBe9lv2ICAqcNpKi
	0OiwX6ArfIrREgwMXMjQz52R8nIEAOnfll4swkI4rKA0Nb1K+XH6YH/hiBMDGs3NaA+L+c
	cIYh3PaG09xlUzwxSJ4qXmQBl2kliJI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-418-Geg4cK_4OEa2q_dZZjsUzw-1; Tue,
 29 Oct 2024 04:01:25 -0400
X-MC-Unique: Geg4cK_4OEa2q_dZZjsUzw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 923661955D42;
	Tue, 29 Oct 2024 08:01:24 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 867BA19560A3;
	Tue, 29 Oct 2024 08:01:22 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:21 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 1/8] trace-cmd lib: Prevent a memory leak in handle_options()
Date: Tue, 29 Oct 2024 09:01:10 +0100
Message-ID: <20241029080117.625177-2-jmarchan@redhat.com>
In-Reply-To: <20241029080117.625177-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
 <20241029080117.625177-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Buf isn't always fred in the error path. Instead of freing buf at the
end of the loop, free it in the exit path and before reallocating it.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-input.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index 8b6e3d0c..ad662fc6 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4006,7 +4006,7 @@ static int handle_options(struct tracecmd_input *handle)
 	char *cpustats = NULL;
 	struct hook_list *hook;
 	bool compress = false;
-	char *buf;
+	char *buf = NULL;
 	int cpus;
 	int ret;
 
@@ -4036,6 +4036,7 @@ static int handle_options(struct tracecmd_input *handle)
 		ret = read4(handle, &size);
 		if (ret)
 			goto out;
+		free(buf);
 		buf = malloc(size);
 		if (!buf) {
 			ret = -ENOMEM;
@@ -4189,14 +4190,12 @@ static int handle_options(struct tracecmd_input *handle)
 			tracecmd_warning("unknown option %d", option);
 			break;
 		}
-
-		free(buf);
-
 	}
 
 	ret = 0;
 
 out:
+	free(buf);
 	if (compress)
 		in_uncompress_reset(handle);
 	return ret;
-- 
2.47.0

