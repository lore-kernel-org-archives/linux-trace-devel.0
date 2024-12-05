Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F0F21C16A
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409905; cv=none; b=G/oN//ZpDrqVXYuRKpuDeIOV12E4Uc2SzyMb0YI9jaXVSus6CjABz2UKBmyxSK6e4Bqgl2l5Q+tNc4cxjh/CKAkWbbrh0XZ26+XcH+jt/oQQGEXl0KK/T/WknBLdZcApl3M6I3WyHsYPOe77kFaiY1RvsJdOs+jom5oFBw5HS6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409905; c=relaxed/simple;
	bh=9n8MepsfEpgC+Q2Ao71oWt0RJtIcsLou+Md6/GRYBaE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jMjXvuhjabZEuLzWvgmSQw74kv1oFy0RmIQtnNrOsyEpub+4zrJSwQJcvcZqkArxceC4IPKhtVSdcoqBY/wgUsXaIv4vQ4FCX1DpRvEOgdxD7serhADURnJAnK9vWX5T6OgkGihajxYgyXKHQTRydGc4TtsPx0nZrFX2Ujz7oxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYrQVKtL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYrQVKtL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409903;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kaLfmf+1Pqv1toM33JaeNFldY8BsGn96nwdrikhDtew=;
	b=OYrQVKtL/ufM62+dvU6GoAi23/YlbtDeZ6u27PEBJrSIgeVK64l5X8mfBjFzMBh5zBBhh3
	wEDks2RBHLSJSXJZp3igiKkX5e4IHYlR4/dChnrlW55kvkspNDVO/FJOGzi0WFXMRRHNko
	ZU/HXtW1v2Z51pXr1vZEqES6W3zN5aM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-356-lIt3Kc8bNJSnxyTs34QQIg-1; Thu,
 05 Dec 2024 09:45:02 -0500
X-MC-Unique: lIt3Kc8bNJSnxyTs34QQIg-1
X-Mimecast-MFC-AGG-ID: lIt3Kc8bNJSnxyTs34QQIg
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 10BA31956057;
	Thu,  5 Dec 2024 14:45:01 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id F1BCC1956094;
	Thu,  5 Dec 2024 14:44:58 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:57 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 5/7] trace-cmd sqlhist: Initialize name in trace_sqlhist()
Date: Thu,  5 Dec 2024 15:44:37 +0100
Message-ID: <20241205144439.127564-6-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

The variable name in trace_sqlhist() can be used uninitialized in
do_sql() if it's not set with -n option. Initialize it to NULL like
the other strings.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 tracecmd/trace-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tracecmd/trace-sqlhist.c b/tracecmd/trace-sqlhist.c
index 9e304e43..9f2b94e6 100644
--- a/tracecmd/trace-sqlhist.c
+++ b/tracecmd/trace-sqlhist.c
@@ -136,7 +136,7 @@ void trace_sqlhist (int argc, char **argv)
 	const char *instance = NULL;
 	bool execute = false;
 	char **save_fields = NULL;
-	const char *name;
+	const char *name = NULL;
 	const char *var = NULL;
 	char **save_argv;
 	int action = 0;
-- 
2.47.0

