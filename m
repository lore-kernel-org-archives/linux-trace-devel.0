Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CA31957F6
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594953; cv=none; b=MSbd5wXW+dJlLSCBJcQ+l6byCgvIaiM7yz7G1wRPsc+S2WR6d+Qk7xOYIbyVl7+V0vnegsxOGH57PdkNEttnSyu06N7jJO50DNLxra1xWPGBEe/hWMGeVyH9P1k4kgVc6mJy5C65Hg9W+fczGg9XK8yq8jAB3tckHiZXsLocm9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594953; c=relaxed/simple;
	bh=7OtPmzMX7Ph+30jLs+nryv8I5gdagJxCkXwDsc0lpps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5Ca50yxPg2NRuLWC0LmlAoS8Xi17B8Y3zZLAX7IcXtXsA/KMGet5Bh5QlYbz0aHJBMA+3ZB+mHZpsRQavsPUNfO45xi29Ll3MXwIBJTrmbt+09NCCjXqM1dRCO4abN1QZU8GOf1TgCFQ1q9guSE7guy8VEEuaCmc/Q1gCuy1PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TT/OEgxP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TT/OEgxP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594950;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xi7J2Y9NUHnwrTU4fxuVIHNFXsP4EBF0vmC3cski0Ps=;
	b=TT/OEgxP7LRTqnAMuOlfagTkn7trzgIwuZfRwqdtyGEGp3rpwvGMnnja29V7lC93Uk6Brc
	6N6DLXc0wOfkV3VFJEBTy/XVom58jtSPHbksmrqeacZVSxJGYNIZbjjaGsfN4H+bKefjBz
	Lm009gxZRcfvn9vBiYtyTXQOjzTcj5s=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-119-KNust7FoOBCvQyd9wA1sgw-1; Wed,
 05 Jun 2024 09:42:28 -0400
X-MC-Unique: KNust7FoOBCvQyd9wA1sgw-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DCB97195E92B;
	Wed,  5 Jun 2024 13:42:27 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 779951956086;
	Wed,  5 Jun 2024 13:42:25 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:23 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 24/38] trace-cmd: close file descriptor in trace_vsock_make()
Date: Wed,  5 Jun 2024 15:40:39 +0200
Message-ID: <20240605134054.2626953-25-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Close the socket file descriptor in the error paths.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-vsock.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tracecmd/trace-vsock.c b/tracecmd/trace-vsock.c
index baa310f7..df1a9800 100644
--- a/tracecmd/trace-vsock.c
+++ b/tracecmd/trace-vsock.c
@@ -43,12 +43,16 @@ int __hidden trace_vsock_make(unsigned int port)
 	setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &(int){1}, sizeof(int));
 
 	if (bind(sd, (struct sockaddr *)&addr, sizeof(addr)))
-		return -errno;
+		goto error;
 
 	if (listen(sd, SOMAXCONN))
-		return -errno;
+		goto error;
 
 	return sd;
+
+error:
+	close(sd);
+	return -errno;
 }
 
 int __hidden trace_vsock_make_any(void)
-- 
2.44.0

