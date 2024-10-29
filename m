Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8272E2038C9
	for <linux-trace-devel@vger.kernel.org>; Tue, 29 Oct 2024 08:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730188900; cv=none; b=fvKZuNwplASnR8SSH9XTCF1imaHK2KNx16pXZRNxckE/SRysYXAWSWN1w+M4dRVoDD3IRbqfdrqduOSMWVMTqpz1pbAXHVIOssxW1Vhun8R397O8xTFPZbBFITLLrYK97PDT9PnOEUU9phfrt2al9LTpxLRrTp8BA0/JvoLG/u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730188900; c=relaxed/simple;
	bh=F4LKKSqlQBR5xasbPDUuFdc/tLzRaxE9/lfyqsxCeKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ON5wU1M5IOYR4Rb2KYUIQ3mlickI4FB6HnGN49+vd2YS6ZQkzCZHtMyPWSOJj9yWw9TkE+iCpYRY1fJwKWYlEv8ff5QceMJuj2o10ReiY10FgN4zmWgDIrimHFcIJcGouw3cQh6JnO0O+t0m1SM67GpumIE9i7XQrlPMudCaW/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=V/ZheVdh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="V/ZheVdh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730188897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=i3r9A8johaFWCNhdmMXpn4m3fhPGaP9hCNGSSFl7TG8=;
	b=V/ZheVdhlAzG9crMn0Nqs4qHMzmBGgfi5hBBMMhtmWf9W2hLYz2VJtjuWSslhKVKfA1PP1
	xWDdRwTnT7fDaRtBzRLnkrKFHIZaqlAM1jX7cuEi08FEHALW/r5XR9tN7UgnhWl/DcFb3X
	pTyUQ3q6/ALlle3fEaqLuNqvdMLGmfc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-648-rhLDQSfzMI-Er8UapvRhdA-1; Tue,
 29 Oct 2024 04:01:36 -0400
X-MC-Unique: rhLDQSfzMI-Er8UapvRhdA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74B9819560B4;
	Tue, 29 Oct 2024 08:01:35 +0000 (UTC)
Received: from fedora (unknown [10.45.224.46])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 6B31B19560A2;
	Tue, 29 Oct 2024 08:01:33 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Tue, 29 Oct 2024 09:01:32 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 4/8] trace-cmd dump: Prevent buffer overrun in dump_clock()
Date: Tue, 29 Oct 2024 09:01:13 +0100
Message-ID: <20241029080117.625177-5-jmarchan@redhat.com>
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
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The clock isn't big enough to hold the string with the null
terminating character. Worse, clock[size], which is out of range, is
set to 0. Allocate a big enough buffer.

Fixes an OVERRUN error (CWE-119)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-dump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-dump.c b/tracecmd/trace-dump.c
index 11c1baf1..0a21356e 100644
--- a/tracecmd/trace-dump.c
+++ b/tracecmd/trace-dump.c
@@ -961,7 +961,7 @@ static void dump_clock(int fd)
 	}
 	if (read_file_number(fd, &size, 8))
 		die("cannot read clock size");
-	clock = calloc(1, size);
+	clock = calloc(1, size + 1);
 	if (!clock)
 		die("cannot allocate clock %lld bytes", size);
 
-- 
2.47.0

