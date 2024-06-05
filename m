Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE012383
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594929; cv=none; b=PHstF6IW9zLOOTsrhbiJOh7amo+IBWF7XIQfu/x5zHXEpy0pavzoa+x1Jd/7gmVfWWAOkuVkVsWP9AZYuDTP1udQ5W5KlTvsZUssCMcw7k4pE1VRJtLbvYn9TjKW3HRslOuc9PKZUYvF97RcHwhuRbGgv6DXPTiefJPEPqdH9i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594929; c=relaxed/simple;
	bh=7d7dXkY3IAwNZNAcOv8rGsLEEJczaT3GcwE6ChWUjEU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mM3stMvuyavvMAzYMkreK27/J+xbLMgOgEoy7RI+4GoXwjGldlUekMNU4nOdET1pBmjNcS2bt7aG3fxx/NlLdl+Pw+SlTszwi3ZaY0q2lG9Q6wsYJeLSHV/FpIIFavu7WMVbf/GNyrN1aRNk0c3DFvX1F7PrEWtofObh0BusuxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HgbwnLfq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HgbwnLfq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GyEnMcCx78hNb7umDffZ40rYs4R4qVE3bhAHJHKN48M=;
	b=HgbwnLfqQLSK/3o8HThWSiruntBEMyMQlkmTwv3Ei2kcwpZrLHFFTLmQXGIF136JRiHwtz
	rB26m+w3DUfCA7V7NZ6HYDN5e9Qno7L5OjGdNO2aNP0xW1zmbA9y/5EORqvdlWocDeSpG8
	ualHv6DXHagQEdxK/HlIK4wWRCCcX4E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-513-ZULXe2AQM5CKRGse4i56-w-1; Wed, 05 Jun 2024 09:42:04 -0400
X-MC-Unique: ZULXe2AQM5CKRGse4i56-w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AFF5D85A588;
	Wed,  5 Jun 2024 13:42:03 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id D74C21C0005E;
	Wed,  5 Jun 2024 13:42:01 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:01 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 18/38] trace-cmd lib: remove useless code in tracecmd_plog()
Date: Wed,  5 Jun 2024 15:40:33 +0200
Message-ID: <20240605134054.2626953-19-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.7

In __plog(), both branch of the "if (newline)" statement are
identical. I guess the original intent was to print a newline if the
last message didn't end in one. But it seems that all messages send to
tracecmd_plog() terminates with a newline and are short enough to not
get truncated.

Remove all newline code that doesn't do anything.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-util.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/lib/trace-cmd/trace-util.c b/lib/trace-cmd/trace-util.c
index 47ca3db1..a4334a98 100644
--- a/lib/trace-cmd/trace-util.c
+++ b/lib/trace-cmd/trace-util.c
@@ -453,7 +453,6 @@ void __weak tracecmd_debug(const char *fmt, ...)
 #define LOG_BUF_SIZE 1024
 static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 {
-	static int newline = 1;
 	char buf[LOG_BUF_SIZE];
 	int r;
 
@@ -463,11 +462,7 @@ static void __plog(const char *prefix, const char *fmt, va_list ap, FILE *fp)
 		r = LOG_BUF_SIZE;
 
 	if (logfp) {
-		if (newline)
-			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
-		else
-			fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
-		newline = buf[r - 1] == '\n';
+		fprintf(logfp, "[%d]%s%.*s", getpid(), prefix, r, buf);
 		fflush(logfp);
 		return;
 	}
-- 
2.44.0

