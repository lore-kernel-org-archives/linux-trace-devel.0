Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25B101974EB
	for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jun 2024 15:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717688366; cv=none; b=qokDPn8kQa2lN7iCcdmDj5qHEB0/0MILVueaTzFDV9oslsYNsHYdVhqDZPKcPLi71w4dhAZdV8uYbCN4znNkigq+YCt8M4Il8nyH9Jk9wKpNOyZRoPD1M3JG6VAopwTnkbWne4qGsL6MipB/JzTfASQwe5n5trfpHU6gTZcS3nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717688366; c=relaxed/simple;
	bh=unNRAobtsTNpQ1l2uEscTLqhtB94EpwMAKjNQ9L4b3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFm89IPs63jVZY10B1cFRfn5tbAwL9z4tvH3+jhWGlYcrFysFBAXOfQjZIXI6qBj0GiGrqDRZ+b9+OHRnkqrrrh/CH/ZWerbMsP0Emk1hx2zxprm4xKtIhyI/lATjJQqp+1iwHde4L8Hm4mo4FeK6KvpCD0zmZKIagx7rxAxYlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E4xqqnct; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E4xqqnct"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717688364;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NsFrhqfv+GimEite5FlAHvC8rOxISXCzfyG5HXm/oxc=;
	b=E4xqqnctinBnj3leqeMOzppi/c2YiIx3rL5jqf63k1El2F88MRXmBWCJZvvbelHHHgYEvj
	+j5C/2Okcv6qOgfMnounwO/7rcE2MtTv7XqkwIA6MjvJS8h4e1vklyxVnAwkyyjEbPLv1g
	x6WkGz5TnsIe7nmMHqHcZG4mEQj20iQ=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-224-FXGH0r_rPUiX5Bqvhw8YiA-1; Thu,
 06 Jun 2024 11:39:22 -0400
X-MC-Unique: FXGH0r_rPUiX5Bqvhw8YiA-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4484185CB83;
	Thu,  6 Jun 2024 15:39:21 +0000 (UTC)
Received: from fedora (unknown [10.45.224.84])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 8F5A6190BA8A;
	Thu,  6 Jun 2024 15:39:15 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 06 Jun 2024 17:39:14 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 15/15] libtracefs: initialize val in build_filter()
Date: Thu,  6 Jun 2024 17:38:29 +0200
Message-ID: <20240606153830.2666120-16-jmarchan@redhat.com>
In-Reply-To: <20240606153830.2666120-1-jmarchan@redhat.com>
References: <20240606153830.2666120-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

In build_filter(), val is only initialized if filter->rval->type is
either EXPR_NUMBER or EXPR_STRING. AS far as I can understand that is
expected at that point. Howvever, it doesn't cost much to initialize
it in case the parser let some bogus request pass by and it should
prevent the static analyser to complain.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/tracefs-sqlhist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 0f678c1..08bd0fa 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1109,7 +1109,7 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
 			     const char *val);
 	struct filter *filter = &expr->filter;
 	enum tracefs_compare cmp;
-	const char *val;
+	const char *val = NULL;
 	int and_or = TRACEFS_FILTER_AND;
 	char num[64];
 	int ret;
-- 
2.44.0

