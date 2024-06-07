Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E9C19AA43
	for <linux-trace-devel@vger.kernel.org>; Fri,  7 Jun 2024 16:05:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717776357; cv=none; b=i1gFCVinwGn99G4OjFfqVhOaV3kzyGuZpegwKo9afareaMJzW6m8QBvcdTi8sJgnE4iBpxKoCzgWlxyfVuVbZhiOOJ/y309jiUs0vjYsJ8OqTQEVPH85Hsb/tMFibM8T5Bxi4ffqneYf5tR09Z9bY1/F9wHrIGNeN++soz4uAgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717776357; c=relaxed/simple;
	bh=vlmqTvB/rVpJ9d42QMAsL6FICRWNRc6Kr/m08Eu2Ueo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eLMnAO8TeTTJbfaCOF0pDk3gXD/hDdfmzKexqsPlpGkeDFhCFICWym9zft4+Vj8m+VpG8x+yohRXAe1YJsYAGvvpbxGDxnWT6ZoQmW79bNKPaMCleQxglVUUHAQYd6fQGLTICcpNSm/TrMyqqnoo46hPoJUsHhXwmM2NPI11Lkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JMzttXzZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JMzttXzZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717776354;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U3hdmgS59moAi7QgEb0UsjD7PlQUjeWMnF7pSp2ll50=;
	b=JMzttXzZGXfWgBAZqGv3IE9+r8iu1dzMnqKk1dvezjfcJu2Kp1InKAAaKeR/+pDmz4Txxf
	vFsbQyriYe4JQdI42ZwjKNmmoMMIBgkEM5XakR/QztTgzGRzLfbU3uz9pCtCOTYtb0OFNS
	4+GiBIqcSCE4r1/UhQJKeGJ34ve9fHc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-689-dH3hPhTtPwuB-MWg78w2LQ-1; Fri,
 07 Jun 2024 12:05:52 -0400
X-MC-Unique: dH3hPhTtPwuB-MWg78w2LQ-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 930AD19560BB;
	Fri,  7 Jun 2024 16:05:51 +0000 (UTC)
Received: from fedora (unknown [10.43.17.163])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 41C271955E80;
	Fri,  7 Jun 2024 16:05:49 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Fri, 07 Jun 2024 18:05:47 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 2/4] libtraceevent: prevent a memory leak in process_fields()
Date: Fri,  7 Jun 2024 18:05:40 +0200
Message-ID: <20240607160542.46152-3-jmarchan@redhat.com>
In-Reply-To: <20240607160542.46152-1-jmarchan@redhat.com>
References: <20240607160542.46152-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

One of the error path after field was allocated go to the wrong label.
Go to out_free_field if the allocation of arg fails.

Fixes a RESOURCE_LEAK error (CWE-772)

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 src/event-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/event-parse.c b/src/event-parse.c
index b625621..9f0522c 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -2963,7 +2963,7 @@ process_fields(struct tep_event *event, struct tep_print_flag_sym **list, char *
 		free_arg(arg);
 		arg = alloc_arg();
 		if (!arg)
-			goto out_free;
+			goto out_free_field;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
-- 
2.45.1

