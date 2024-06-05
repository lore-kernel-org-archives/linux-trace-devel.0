Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F187F1957FB
	for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jun 2024 13:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717594963; cv=none; b=RkgD4R4ZgYJrJjBpDvs+L73unVs/3BfSZeX/tStGIrY2ke22tuGwYBAq8KQdPC03rVQNgc9JdakDlJWl4v0HmfDTgJ0eOBe74bnJRGY5Js1dKmtSJdPP98tLaZKQIbLJLtsiSmzzitTv1k4u85Ps5lm8LeTWqFJAcVM4f2km820=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717594963; c=relaxed/simple;
	bh=AxtAwmDYqa7/1ZOz7DCVdBqsTzasCLhjtGCHB8Bd2DQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tyKQ8f+NuOmxz0j8gr8sxVKuEi6KI+DUXWWTYDUNIwXqQQKDwnqK3xC0BeZ+fVT/K0Sn6vNI+HVp+sL+2bHNg/0r4eYoCiy7HrasV3NEs6oxU+lSlkPQf1xkMkFQvu39Rcs/0lemg1x6CLnOyVCWyuEVcEh4ShUC/w7OLKL9rS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=d7IXsJwL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="d7IXsJwL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717594961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/D0JS99Ps6t+1OFBOSTvqCizS1L3blN75IH206VAQw=;
	b=d7IXsJwLnnMKev7ORNHfmbxRwci0xrXOVAVd/JkOA5/U4qcy1fJm60S+HJD3tcwUgYxAlY
	Uns62DiubQWLq0q7EctJqkQg91Ee/Ke+mHmv+9NCPYKrVzpI+JfWgQdmkBiVz4zEuAE97f
	lpLLe5vMzv0OFApns113E5mrDdWMmkI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-332-boNdEVK5MzaVrmE1oOKH3w-1; Wed, 05 Jun 2024 09:42:37 -0400
X-MC-Unique: boNdEVK5MzaVrmE1oOKH3w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 963B7185B948;
	Wed,  5 Jun 2024 13:42:37 +0000 (UTC)
Received: from fedora (unknown [10.45.225.116])
	by smtp.corp.redhat.com (Postfix) with SMTP id C101B40D1B68;
	Wed,  5 Jun 2024 13:42:35 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Wed, 05 Jun 2024 15:42:35 +0200
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 27/38] trace-cmd lib: prevent a possible file descriptor leak in set_proc_kptr_restrict()
Date: Wed,  5 Jun 2024 15:40:42 +0200
Message-ID: <20240605134054.2626953-28-jmarchan@redhat.com>
In-Reply-To: <20240605134054.2626953-1-jmarchan@redhat.com>
References: <20240605134054.2626953-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.2

In set_proc_kptr_restrict() we test whether fd > 0 to close it.
Theorically, open() could have returned zero if stdin was closed. I
don't think it could happen here, but changing the test with fd >= 0
silence the static analyser which complains about a ressource leak.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/trace-cmd/trace-output.c b/lib/trace-cmd/trace-output.c
index 7be175af..6a9606c7 100644
--- a/lib/trace-cmd/trace-output.c
+++ b/lib/trace-cmd/trace-output.c
@@ -1124,7 +1124,7 @@ static void set_proc_kptr_restrict(int reset)
 	if (write(fd, &buf, 1) > 0)
 		ret = 0;
 err:
-	if (fd > 0)
+	if (fd >= 0)
 		close(fd);
 	if (ret)
 		tracecmd_warning("can't set kptr_restrict");
-- 
2.44.0

