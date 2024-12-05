Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA5A7218E83
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409900; cv=none; b=IeY0q3nUxxuA69XyqeMPrYcNTQ3CTWyHI/fvVbDHAL8DBdE+tehlGFyPHJ1VA3H+2E0HNLnDH0v8g9LZhBd/fRDXW0vNwGkDI/YYm6OmtRRDUNIf5TnDw/bkk0JcDAHMlzsxjaRyrkiezmZ0sTrN59oH41r5WP1kykw6r0QrcB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409900; c=relaxed/simple;
	bh=72ZcV2vNkfHw/o2TG8iWu5XdMzxOsDla7tdDpPFkGf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NGNIo9SZznG8gjwp4boeflecCQFN+nr0ln+mGJ9Ku1JoDC5EfY4AYrWdnPTwoT641tvU/4EDYQJbwsz8sXNqC70UbBryHCYPHzJMdZBTJHtyUNvCyDA1sctXZJsBpnFa+WnTPOInc+0ZXZZxHLY3paLFw0nQOy2vNKMuEkA0kcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=h7C70N1K; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h7C70N1K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe49G6cQeFFSE/V3PIb+RPJRO8lyhkyG8DwutMFAqyE=;
	b=h7C70N1KGh6RfVKRgzpce8yRCIbv9m9wIAEd9KoQaSx3T7rNUrWJctsnZROeN5k004hnX+
	Yy/nwUh0GE/fvJhkFHIIU0ITz3AU5Rbxc8oTe6RGuyS6RDfQVSjbkLAsaJi64O7gxFRc7H
	V0TZF4GFXiMGWfZk2TkoHHiGhLPz638=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-611-004PoHg4PJ-rr505Sdiz9A-1; Thu,
 05 Dec 2024 09:44:54 -0500
X-MC-Unique: 004PoHg4PJ-rr505Sdiz9A-1
X-Mimecast-MFC-AGG-ID: 004PoHg4PJ-rr505Sdiz9A
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E9B8219560B5;
	Thu,  5 Dec 2024 14:44:53 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 030FC1955F3E;
	Thu,  5 Dec 2024 14:44:51 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:50 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 3/7] trace-cmd lib: Prevent a leaked FD in __tracecmd_create_buffer_recorder()
Date: Thu,  5 Dec 2024 15:44:35 +0100
Message-ID: <20241205144439.127564-4-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Close fd if the allocation of file2 fails in
__tracecmd_create_buffer_recorder().

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-recorder.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-recorder.c b/lib/trace-cmd/trace-recorder.c
index 0413e529..f02c3a55 100644
--- a/lib/trace-cmd/trace-recorder.c
+++ b/lib/trace-cmd/trace-recorder.c
@@ -193,8 +193,10 @@ __tracecmd_create_buffer_recorder(const char *file, int cpu, unsigned flags,
 		int len = strlen(file);
 
 		file2 = malloc(len + 3);
-		if (!file2)
+		if (!file2) {
+			close(fd);
 			return NULL;
+		}
 
 		sprintf(file2, "%s.1", file);
 
-- 
2.47.0

