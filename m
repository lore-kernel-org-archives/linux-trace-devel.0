Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC39196DAA
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688338; cv=none; b=d4xSeXypyG85Df+wr728lEKaGwBTgvO2Cqa4PFkErHzvllGPsSrVHzIv5jL95f/YE1DsmevIbFs4rCFSobaGr81850V0XODF/sSuu9TwYGiE+s0Fz7rWfJ0QgT4Zyqe9Inv7lcxeLvyy3EVtKh+uFkUkmmbZ88Wi79ZZc1gUUF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688338; c=relaxed/simple;
	bh=mA+NmsKenoalLv++MAAk2NzT60ktY8LmNgcAlCHXWiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrvObk8e8qEQsNi61G+B8LnnFxHjvMLzDXoLYc8/pVTuE+muoPgrgI4mmHIWYEv770tg5/JCL3yIdBjNEjEDV7U8R2zZpCT3CIIrb/0kLX6PslZ5OugZoHzquzH1pr6VeMm8lYP+3wn+JKl+r/prsWmU60gxC7A51ZjxrE+2Ux4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IE5mbfAT; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IE5mbfAT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YqmvRulF+1oPzhby+vjXwSbcyWnJ7OsoW6q+Hwa3YnM=;
	b=IE5mbfAT4u8KDP0mPBuMq5+uLB6J9DtfFceTe8LjC/u1YoQZBJTw7151LkhmhjKRyCiHnc
	rrUGpV4FG51WastmGLwUmzD5cRdXNF26xYhiAnE5OU4k6YJ5JBeS1A6Egs5fRLl8IIC/iw
	1fnV4aIkvyxpL2/UIKki2lBrsbKFLEE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-553-EbMHsZecMS6AOhfm4eIigQ-1; Thu,
 06 Jun 2024 11:38:53 -0400
X-MC-Unique: EbMHsZecMS6AOhfm4eIigQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 86E2C1933B7A;
	Thu,  6 Jun 2024 15:38:52 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 72E953001E83;
	Thu,  6 Jun 2024 15:38:50 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:49 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 06/15] libtracefs: don't leak socket file descriptor in open_vsock()
Date: Thu,  6 Jun 2024 17:38:20 +0200
Message-ID: <20240606153830.2666120-7-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Close the socket file descriptor if connect() fails.

Fixes a RESSOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-vsock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-vsock.c b/src/tracefs-vsock.c
index e171382..9171321 100644
--- a/src/tracefs-vsock.c
+++ b/src/tracefs-vsock.c
@@ -19,8 +19,10 @@ static int open_vsock(unsigned int cid, unsigned int port)
 	if (sd < 0)
 		return -1;
 
-	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr)))
+	if (connect(sd, (struct sockaddr *)&addr, sizeof(addr))) {
+		close(sd);
 		return -1;
+	}
 
 	return sd;
 }
-- 
2.44.0

