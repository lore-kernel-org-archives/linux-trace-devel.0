Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC00196C63
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688320; cv=none; b=CQLtR8dgejjJYTLH0WCDO8uc5xiu6sWj59qTcye/Z/MlLojOM/0l74xkMnYNbzQlELW+mob+5I+HtTS+qitWusUio8OLndpA4pM6c+Izr50a28X+5x8eqLtJFMdZFk96VhSt2ME+M3hWDZycxMjzTeMRjyIgry3Aly+G4bWSFVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688320; c=relaxed/simple;
	bh=Ewmr86j6zQiow2wK/o8Yf2Cxz4qrAUxB6Inmq5gkrW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B8bYKzkq89uhuaVWy/jf1q2h/OKc4MGAU7cufpczSus5CjQ87TBhYJFLlm8dq+oeNNjuPfzf6SFjrddZpOudpgkpK9rWbmhJ0bqzM/DPBBbSqgFVcniRZAHLqBrEsupHjwMDPVCJRGbJuGjybMkeTL3vGYDrvxD6gB6ikra68u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Et79uojM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Et79uojM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HgpeHS1N7ftisvO29XBLOP8taTOvhyj7LfctCgVWeXk=;
	b=Et79uojMcev8edaDV/uODS+5AtXNMh8NSfDeHxYbQJTmq9cZUI7GLWf53pS875+tJJ5u0f
	u/KPS738qH2lvfJd/4nv7v6P3YhIxFh1a7qIhvEnRFAIzE9soPaRkeTLFI/pZ8lIG55Un5
	cUYxyoah8V1EU7pLrYfAZ/JyzK3wU6o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-155-0zHbpkl-N6SZqhlWjZwuZQ-1; Thu, 06 Jun 2024 11:38:36 -0400
X-MC-Unique: 0zHbpkl-N6SZqhlWjZwuZQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0B7B68007A1;
	Thu,  6 Jun 2024 15:38:36 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by smtp.corp.redhat.com (Postfix) with SMTP id 60E0F40C6DB3;
	Thu,  6 Jun 2024 15:38:34 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:38:33 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 01/15] libtracefs: call va_end() before exiting tracefs_hist_set_sort_key()
Date: Thu,  6 Jun 2024 17:38:15 +0200
Message-ID: <20240606153830.2666120-2-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

Each invocation of va_start() must be matched by a corresponding
invocation of va_end() in the same function. If add_sort_key() fails,
tracefs_hist_set_sort_key() exits without calling it. Call va_end
after add_sort_key() fails.

Fixes a VARARGS error (CWE-237)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-hist.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-hist.c b/src/tracefs-hist.c
index 2b4f17f..87287b5 100644
--- a/src/tracefs-hist.c
+++ b/src/tracefs-hist.c
@@ -596,8 +596,10 @@ int tracefs_hist_set_sort_key(struct tracefs_hist *hist,
 		if (!sort_key)
 			break;
 		tmp = add_sort_key(hist, sort_key, list);
-		if (!tmp)
+		if (!tmp) {
+			va_end(ap);
 			goto fail;
+		}
 		list = tmp;
 	}
 	va_end(ap);
-- 
2.44.0

